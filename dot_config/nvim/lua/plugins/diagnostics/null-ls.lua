local M = { "nvimtools/none-ls.nvim" }

M.event = "User FilePost"

M.config = function()
  local null_ls = require "null-ls"
  --- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
  local diagnostics = null_ls.builtins.diagnostics
  local settings = {
    debug = true,
    sources = {
      -- general
      diagnostics.semgrep, -- code standards
      -- ruby
      diagnostics.rubocop,
      -- ansible
      diagnostics.ansiblelint,
      -- terraform
      diagnostics.terraform_validate,
      diagnostics.tfsec,
      -- python
      diagnostics.mypy,
    },
  }

  null_ls.setup(settings)
end

return M
