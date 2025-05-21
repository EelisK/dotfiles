-- LSP configuration using the built-in LSP client
--
--  ██▓      ██████  ██▓███
-- ▓██▒    ▒██    ▒ ▓██░  ██▒
-- ▒██░    ░ ▓██▄   ▓██░ ██▓▒
-- ▒██░      ▒   ██▒▒██▄█▓▒ ▒
-- ░██████▒▒██████▒▒▒██▒ ░  ░
-- ░ ▒░▓  ░▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░
-- ░ ░ ▒  ░░ ░▒  ░ ░░▒ ░
--   ░ ░   ░  ░  ░  ░░
--     ░  ░      ░
--

local handlers = require "lsp.handlers"

---@return string[]
local function get_lsp_servers()
  local lsp_dir = vim.fn.stdpath "config" .. "/lsp"
  local lsp_servers = {}

  if vim.fn.isdirectory(lsp_dir) == 1 then
    for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
      if file:match "%.lua$" and file ~= "init.lua" then
        local server_name = file:gsub("%.lua$", "")
        table.insert(lsp_servers, server_name)
      end
    end
  end

  return lsp_servers
end

-- Neovim will call config() for the merged tables in `nvim/lsp/<name>.lua` as well as explicit calls
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("eelisk.lsp", { clear = true }),
  callback = handlers.on_attach,
})

-- Enable the servers!
vim.lsp.enable(get_lsp_servers())
