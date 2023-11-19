---@type MappingsTable
local M = {}

-- Modes (see :h map-modes)
-- n Normal Mode
-- x Visual Mode
-- s Select Mode
-- v Visual + Select Mode
-- o Operator-Pending Mode
-- i Insert Mode
-- c Command-Line Mode
-- l Insert + Command-Line + Lang-Arg Mode

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["n"] = { "nzzzv" },
    ["N"] = { "Nzzzv" },
    ["<C-d>"] = { "<C-d>zz" },
    ["<C-u>"] = { "<C-u>zz" },
  },
  v = {
    [">"] = { ">gv", "indent" },
    ["<"] = { "<gv", "unindent" },
  },
}

return M
