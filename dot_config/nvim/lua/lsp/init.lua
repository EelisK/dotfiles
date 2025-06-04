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
local icons = require "icons"
local lsp_dir = vim.fn.stdpath "config" .. "/lsp"
---@type table<string, boolean>
local enabled_servers = vim.g.eelisk_lsp_servers or {}

---@return string[]
local function get_lsp_servers()
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

---Setup an LSP server by loading its configuration file and creating an autocmd to enable it.
---@param server string
local function setup_lsp(server)
  ---@type boolean, vim.lsp.Config
  local ok, server_config = pcall(dofile, lsp_dir .. "/" .. server .. ".lua")
  if not ok then
    vim.api.nvim_echo({
      { ("LSP server '%s' is not configured properly: %s"):format(server, server_config), "ErrorMsg" },
    }, true, {})
    return
  end

  -- Only handle servers with the `cmd` field is a non-empty table
  if type(server_config.cmd) ~= "table" or #server_config.cmd == 0 then
    vim.api.nvim_echo({
      { ("LSP server '%s' is not configured properly: missing 'cmd' field"):format(server), "ErrorMsg" },
    }, true, {})
    return
  end

  local executable = server_config.cmd[1]
  if not vim.fn.executable(executable) then
    vim.api.nvim_echo({
      { ("LSP server '%s' is not executable: %s"):format(server, executable), "ErrorMsg" },
    }, true, {})
    return
  end

  local group = vim.api.nvim_create_augroup("eelisk/lsp/enable/" .. server, { clear = true })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = server_config.filetypes,
    callback = function()
      if enabled_servers[server] then
        return
      end
      vim.lsp.enable(server)
      enabled_servers[server] = true
    end,
  })

  vim.api.nvim_create_autocmd("BufWinLeave", {
    group = group,
    pattern = server_config.filetypes,
    callback = function()
      if not vim.fn.bufexists(vim.fn.bufnr()) then
        local active_clients = vim.lsp.get_clients { name = server }
        vim.lsp.stop_client(active_clients)
        enabled_servers[server] = false
      end
    end,
  })
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

-- settings and mappings for the diagnostic framework
vim.diagnostic.config {
  virtual_lines = { current_line = true },
  float = {
    border = "rounded",
  },
  virtual_text = { prefix = "" },
  signs = {
    text = icons.diagnostic.text,
  },
  underline = true,
  update_in_insert = false,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("eelisk/lsp", { clear = true }),
  callback = handlers.on_attach,
})

-- Create a autocmds to enable an LSP server when an associated filetype is opened.
for _, server in ipairs(get_lsp_servers()) do
  setup_lsp(server)
end
