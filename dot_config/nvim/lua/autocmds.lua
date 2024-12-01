local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

local ansibleFTPatterns = {
  "*/playbooks/*.yml",
  "*/playbooks/*.yaml",
  "*/roles/*/tasks/*.yml",
  "*/roles/*/tasks/*.yaml",
  "*/roles/*/handlers/*.yml",
  "*/roles/*/handlers/*.yaml",
  "*/roles/*/meta/*.yml",
  "*/roles/*/meta/*.yaml",
  "*/roles/*/defaults/*.yml",
  "*/roles/*/defaults/*.yaml",
  "*/roles/*/vars/*.yml",
  "*/roles/*/vars/*.yaml",
  "*/group_vars/*.yml",
  "*/group_vars/*.yaml",
  "*/host_vars/*.yml",
  "*/host_vars/*.yaml",
}

for _, pattern in ipairs(ansibleFTPatterns) do
  autocmd({ "BufNewFile", "BufRead" }, {
    pattern = pattern,
    command = "setlocal filetype=yaml.ansible",
  })
end

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*/testdata/*.txt",
  command = "setlocal filetype=testscript",
})

autocmd("LspAttach", {
  callback = function(args)
    vim.schedule(function()
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client then
        local signatureProvider = client.server_capabilities.signatureHelpProvider
        if signatureProvider and signatureProvider.triggerCharacters then
          require("lsp.signature").setup(client, args.buf)
        end
      end
    end)
  end,
})

-- reload neovim on save
autocmd("BufWritePost", {
  pattern = vim.tbl_map(function(path)
    return vim.fs.normalize(vim.uv.fs_realpath(path))
  end, vim.fn.glob(vim.fn.stdpath "config" .. "/lua/**/*.lua", true, true, true)),
  group = augroup("ReloadNnvim", {}),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

    if module then
      require("plenary.reload").reload_module(module)
    end
  end,
})

-- Disable autocomment on enter
local disableautocomment = augroup("disableautocomment", { clear = true })
autocmd({ "BufEnter", "CmdLineLeave" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = disableautocomment,
})

-- Auto imports and format on save for golang
local autoimportformatgo = augroup("autoimportformatgo", { clear = true })
autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function(event)
    if vim.g.disable_autoformat or vim.b[event.buf].disable_autoformat then
      return
    end
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format { async = false }
  end,
  group = autoimportformatgo,
})

-- Highlight on yank
local yankhighlight = augroup("yankhighlight", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yankhighlight,
})

-- apply dotenv changes automatically on save
autocmd("BufWritePost", {
  pattern = vim.fn.expand "~" .. "/.local/share/chezmoi/*",
  callback = function()
    local cmd = 'chezmoi apply --source-path "' .. vim.fn.expand "%:p" .. '"'
    local handle
    handle, _ = vim.loop.spawn("sh", {
      args = { "-c", cmd },
      detach = true,
    }, function()
      handle:close()
    end)
  end,
})
