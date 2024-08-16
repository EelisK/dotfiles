local null_ls = require "null-ls"
--- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
local b = null_ls.builtins

local settings = {
  debug = false,
  sources = {
    -- general
    b.diagnostics.semgrep, -- code standards
    b.code_actions.refactoring,

    -- go
    b.formatting.goimports,
    b.formatting.gofmt,
    b.formatting.golines,
    b.formatting.gofumpt.with {
      command = "gofumpt",
      args = { "-extra" },
    },
    b.diagnostics.golangci_lint,

    -- ruby
    b.formatting.rubocop.with {
      command = "rubocop",
      args = {
        "--autocorrect-all",
        "--format",
        "quiet",
        "--debug",
        "$FILENAME",
      },
      exit_codes = { 0, 1 },
      async = false,
    },
    b.diagnostics.rubocop,

    -- ansible
    b.diagnostics.ansiblelint,

    -- scala
    b.formatting.scalafmt,

    -- terraform
    b.diagnostics.terraform_validate,
    b.diagnostics.tfsec,
    b.formatting.terraform_fmt,

    -- yaml
    b.diagnostics.yamllint,
  },
}

return settings
