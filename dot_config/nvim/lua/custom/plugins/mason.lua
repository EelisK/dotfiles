-- Language Server Protocol (LSP) client configurations

---@type NvPluginSpec
local M = {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      -- general
      "semgrep",
      "codespell",
      -- shell
      "shellcheck",
      "beautysh",
      -- lua
      "lua-language-server",
      "stylua",
      -- web dev
      "css-lsp",
      "html-lsp",
      "typescript-language-server",
      "deno",
      "prettier",
      -- c/cpp
      "clangd",
      "clang-format",
      -- python
      "pyright",
      "ruff",
      "black",
      "mypy",
      -- terraform
      "terraform-ls",
      "tfsec",
      "tflint",
      -- go
      "gopls",
      "goimports",
      "golines",
      -- ansible
      "ansible-language-server",
      "ansible-lint",
      -- yaml
      "yamllint",
      -- rust
      "rust-analyzer",
      -- ruby
      "rubocop",
      "solargraph",
    },
  },
}

return M
