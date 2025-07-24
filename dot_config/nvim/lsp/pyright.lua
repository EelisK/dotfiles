---
--- https://github.com/microsoft/pyright
---
--- `pyright`, a static type checker and language server for python

local function set_python_path(path)
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  }
  for _, client in ipairs(clients) do
    if client.settings then
      ---@diagnostic disable-next-line: param-type-mismatch
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    client.notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

---@param _ vim.lsp.Client
---@param bufnr number
local function on_attach(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
    desc = "Reconfigure pyright with the provided python path",
    nargs = 1,
    complete = "file",
  })
end

---@param _ lsp.InitializeParams
---@param config vim.lsp.Config
local function before_init(_, config)
  local sep = package.config:sub(1, 1) -- Get the path separator ("/" or "\")
  local root_dir = config.root_dir:gsub("/", sep) -- Normalize root_dir for the current OS

  -- Check for .venv or venv directories
  local venv_path = root_dir .. sep .. ".venv"
  ---@diagnostic disable-next-line: undefined-field
  if not vim.loop.fs_stat(venv_path) then
    venv_path = root_dir .. sep .. "venv"
  end

  -- Determine the Python executable path
  local python_path
  local bin_path = venv_path .. sep .. "bin"
  if vim.loop.fs_stat(bin_path) and vim.loop.fs_stat(bin_path .. sep .. "python") then
    python_path = bin_path .. sep .. "python"
  else
    local scripts_path = venv_path .. sep .. "Scripts"
    if vim.loop.fs_stat(scripts_path) and vim.loop.fs_stat(scripts_path .. sep .. "python.exe") then
      python_path = scripts_path .. sep .. "python.exe"
    end
  end

  -- Set the pythonPath in the config settings
  if python_path then
    ---@diagnostic disable-next-line: param-type-mismatch
    config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = python_path })
  end
end

---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    python = {
      pythonPath = "python3", -- Default to system python
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_attach = on_attach,
  before_init = before_init,
}
