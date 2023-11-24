---@type UIConfig
local M = {}
M.theme = "jellybeans"
M.theme_toggle = { "jellybeans", "one_light" }

M.nvdash = {
	load_on_startup = true,
}
M.cheatsheet = {
	theme = "grid",
}

-- Highlight overrides
-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors
M.hl_override = {
	Comment = {
		italic = true,
	},
}
M.hl_add = {
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M