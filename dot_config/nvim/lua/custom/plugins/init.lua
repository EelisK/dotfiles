local utils = require "custom.utils"

local current_dir = debug.getinfo(1).source:match "@?(.*/)"

-- Automatically load all modules in this directory
local modules = utils.get_modules_in_directory {
  directory = current_dir,
  blacklist = { "init.lua" },
}

---@type NvPluginSpec[]
local plugins = {}
for _, module in ipairs(modules) do
  plugins[#plugins + 1] = require("custom.plugins." .. module)
end

return plugins
