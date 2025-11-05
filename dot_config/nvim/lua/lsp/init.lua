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

  local group = vim.api.nvim_create_augroup("eelisk/lsp/" .. server, { clear = true })
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

  local attached_buffers = {}
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == server then
        attached_buffers[args.buf] = true

        vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
          buffer = args.buf,
          once = true,
          callback = function()
            attached_buffers[args.buf] = nil
            -- If no more buffers are attached, stop the client
            if next(attached_buffers) == nil then
              local active_clients = vim.lsp.get_clients { name = server }
              vim.lsp.stop_client(active_clients)
              enabled_servers[server] = false
            end
          end,
        })
      end
    end,
  })
end

-- Neovim will call config() for the merged tables in `nvim/lsp/<name>.lua` as well as explicit calls
vim.lsp.config("*", {
  capabilities = handlers.capabilities,
  root_markers = { ".git" },
})

-- settings and mappings for the diagnostic framework
vim.diagnostic.config {
  virtual_lines = false,
  virtual_text = {
    prefix = "",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  float = {
    border = "rounded",
  },
  underline = {
    severity = { min = vim.diagnostic.severity.INFO },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
      [vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostic.info,
      [vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
    },
  },
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
