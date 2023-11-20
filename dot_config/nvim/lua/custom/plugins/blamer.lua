---@type NvPluginSpec
local M = {
  "APZelos/blamer.nvim",
  event = { "BufReadPre" },
  config = function()
    vim.g.blamer_enabled = 1
    vim.g.blamer_delay = 30
    vim.g.blamer_relative_time = 1
  end,
}

return M
