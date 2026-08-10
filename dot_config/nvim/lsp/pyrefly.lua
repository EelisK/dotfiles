---
--- https://pyrefly.org/
---
---`pyrefly`, a faster Python type checker written in Rust.
--

---@type vim.lsp.Config
return {
  cmd = { "pyrefly", "lsp" },
  filetypes = { "python" },
  root_markers = {
    "pyrefly.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    -- Pyrefly reuses pyright's settings namespace
    python = {
      analysis = {
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          ---@type "all" | "partial" | "off"
          callArgumentNames = "all",
        },
      },
    },
  },
  on_exit = function(code, _, _)
    vim.schedule(function()
      vim.notify("Closing Pyrefly LSP exited with code: " .. code, vim.log.levels.INFO)
    end)
  end,
}
