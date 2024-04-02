require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
  callback = function()
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
  command = 'silent ! chezmoi apply --source-path "%"',
})
