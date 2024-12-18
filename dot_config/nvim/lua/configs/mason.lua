local M = {
  ---@type '"prepend"' | '"append"' | '"skip"'
  PATH = "prepend",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },

  ensure_installed = {
    -- general
    "semgrep",
    "codespell",
    -- shell
    "shellcheck",
    "beautysh",
    "bash-language-server",
    "shfmt",
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
    "debugpy",
    -- terraform
    "terraform-ls",
    "tfsec",
    "tflint",
    -- go
    "gopls",
    "goimports",
    "golines",
    "golangci-lint",
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
    -- sql
    "sqlfluff",
    -- proto
    "buf",
  },

  max_concurrent_installers = 10,
}

return M
