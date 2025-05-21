---@type LazyConfig
---@diagnostic disable-next-line: missing-fields
local config = {
  root = vim.fn.stdpath "data" .. "/lazy", -- plugin installation directory
  defaults = { lazy = true },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "melange" },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  spec = {
    { import = "ext.plugins" },
  },
}

return config
