local M = {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "aquasecurity/vim-tfsec",
  },
  config = function()
    require "configs.conform"
  end,
}

return M
