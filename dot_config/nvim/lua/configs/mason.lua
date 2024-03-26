local settings = {
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
}

return settings
