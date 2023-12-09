---@type ChadrcConfig
local M = {}

-- check core.mappings for table structure
M.mappings = require "custom.configs.mappings"
M.plugins = "custom.plugins"
M.ui = require "custom.ui"

return M
