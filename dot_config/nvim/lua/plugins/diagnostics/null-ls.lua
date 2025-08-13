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
      diagnostics.mypy.with {
        args = function(params)
          local opts = {
            -- default options
            "--hide-error-codes",
            "--hide-error-context",
            "--no-color-output",
            "--show-absolute-path",
            "--show-column-numbers",
            "--show-error-codes",
            "--no-error-summary",
            "--shadow-file",
            -- custom options
            "--pretty",
            "--strict",
            "--warn-unused-configs",
            "--warn-unused-ignores",
            "--namespace-packages",
            "--explicit-package-bases",
          }
          local config = params.cwd .. "/pyproject.toml"
          ---@diagnostic disable-next-line: undefined-field
          if vim.loop.fs_stat(config) then
            table.insert(opts, "--config")
            table.insert(opts, config)
          end
          table.insert(opts, params.bufname)
          table.insert(opts, params.temp_path)
          table.insert(opts, params.bufname)
          return opts
        end,
      },
    },
  }

  null_ls.setup(settings)
end

return M
