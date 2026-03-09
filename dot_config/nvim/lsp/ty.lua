---
--- https://github.com/astral-sh/ty
---
--- A Language Server Protocol implementation for ty, an extremely fast Python type checker and language server, written in Rust.
---
--- For installation instructions, please refer to the [ty documentation](https://github.com/astral-sh/ty/blob/main/README.md#getting-started).

---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  settings = {
    ty = {
      showSyntaxErrors = true,
      disableLanguageServices = false,
      ---@type "off" | "workspace" | "openFilesOnly"
      diagnosticMode = "openFilesOnly",
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      completions = {
        autoImport = true,
      },
      configuration = {
        rules = {
          ["unresolved-reference"] = "warn",
        },
      },
    },
  },
  init_options = {
    ---@type "trace" | "debug" | "info" | "warn" | "error"
    logLevel = "info",
  },
}
