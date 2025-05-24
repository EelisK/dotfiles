---@param client vim.lsp.Client
---@param _ number
local function on_attach(client, _)
  client.server_capabilities.hoverProvider = false
end

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
  on_attach = on_attach,
}
