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

-- process chezmoi .tmpl files as they didn't have a .tmpl suffix
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = vim.fn.expand "~" .. "/.local/share/chezmoi/*.tmpl",
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf):match ".*/(.*)"
    -- ignore files with leading dot
    if string.match(file, "^%.") then
      return
    end
    local base_name = file:gsub(".tmpl$", "")
    base_name = base_name:gsub("^dot_", ".")
    if base_name then
      local filetype = vim.filetype.match { filename = base_name }
      if filetype then
        vim.api.nvim_set_option_value("filetype", filetype, { buf = args.buf })
      end
    end
  end,
})

autocmd({ "ColorScheme" }, {
  desc = "Make all backgrounds transparent",
  group = vim.api.nvim_create_augroup("nobg", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.o.background == "light" then
      return
    end
    local groups = {
      "Normal",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "BufferLineFill",
      "DiagnosticError",
      "Float",
      "NvimFloat",
      "DiagnosticFloatingError",
      "CocDiagnosticError",
      "NormalFloat",
    }
    -- trying to make the popup opaque
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = nil, ctermbg = nil })
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

-- reload neovim on save
autocmd("BufWritePost", {
  pattern = vim.tbl_map(function(path)
    local realpath = vim.uv.fs_realpath(path)
    if not realpath then
      return path
    end
    return vim.fs.normalize(realpath)
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
    ---@diagnostic disable-next-line: missing-fields
    handle, _ = vim.loop.spawn("sh", {
      args = { "-c", cmd },
      detach = true,
    }, function()
      handle:close()
    end)
  end,
})
