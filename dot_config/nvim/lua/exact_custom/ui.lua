---@type UIConfig
local M = {}
M.theme = "melange"
M.theme_toggle = { "melange", "wombat" }

M.nvdash = {
	load_on_startup = false,
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
M.tabufline = {
	show_numbers = false,
	enabled = true,
	lazyload = false,
}
M.statusline = {
	theme = "vscode",
}
M.hl_add = {
	NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

M.transparency = true

return M
