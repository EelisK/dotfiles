local M = {}

M.ui = {

	theme = "melange",

	nvdash = { load_on_startup = false },
	cheatsheet = { theme = "grid" },

	hl_override = { Comment = { italic = true } },
	tabufline = { show_numbers = false, enabled = true, lazyload = false },
	statusline = { theme = "vscode" },
	hl_add = { NvimTreeOpenedFolderName = { fg = "green", bold = true } },

	transparency = true,
}

return M
