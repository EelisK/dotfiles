local utils = require "utils"

local current_dir = debug.getinfo(1).source:match "@?(.*/)"

-- Automatically load all modules in this directory
local modules = utils.get_modules_in_directory {
  directory = current_dir,
  blacklist = { "init.lua" },
}

local plugins = {}
for _, module in ipairs(modules) do
  plugins[#plugins + 1] = require("plugins." .. module)
end

return plugins
