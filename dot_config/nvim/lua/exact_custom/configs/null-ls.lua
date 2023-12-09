local null_ls = require "null-ls"

--- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local b = null_ls.builtins

local sources = {

  -- general
  b.diagnostics.semgrep, -- code standards
  b.code_actions.refactoring,

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- go
  b.formatting.goimports,
  b.diagnostics.gospel,
  b.formatting.gofmt,
  b.formatting.golines,

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

  -- shell
  b.code_actions.shellcheck,
  b.diagnostics.shellcheck,
  b.formatting.beautysh,

  -- ansible
  b.diagnostics.ansiblelint,

  -- git
  b.code_actions.gitsigns,

  -- terraform
  b.diagnostics.terraform_validate,
  b.diagnostics.tfsec,
  b.formatting.terraform_fmt,

  -- python
  b.formatting.isort,
  b.formatting.black,
  b.diagnostics.flake8,
  b.diagnostics.mypy,

  -- yaml
  b.diagnostics.yamllint,
}

null_ls.setup {
  debug = false,
  sources = sources,
}
