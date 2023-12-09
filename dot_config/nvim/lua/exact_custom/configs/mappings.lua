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

M.disabled = {
	n = {
		-- disable default nvimtree toggle
		-- as it collides with visual-multi
		["<C-n>"] = "",
	},
}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["n"] = { "nzzzv" },
		["N"] = { "Nzzzv" },
		["<C-d>"] = { "<C-d>zz" },
		["<C-u>"] = { "<C-u>zz" },
		["<C-t>"] = { "<cmd>NvimTreeToggle<cr>", "toggle nvimtree" },
		["€"] = { "$", "go to end of line" },
		["¤"] = { "$", "go to end of line" },
		["<leader>gg"] = { "<cmd>LazyGit<cr>", "open lazygit" },
		["<leader>tt"] = { "<cmd>lua require('base46').toggle_theme()<cr>", "toggle theme" },
		["<leader>aa"] = { "<cmd>FigCommentPrompt<cr>", "comment with ascii art" },
	},
	v = {
		[">"] = { ">gv", "indent" },
		["<"] = { "<gv", "unindent" },
	},
}

return M
