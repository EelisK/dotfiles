-- File Explorer
local M = {
	"nvim-tree/nvim-tree.lua",
	opts = {
		git = {
			enable = true,
			ignore = false,
		},

		renderer = {
			highlight_git = true,
			icons = {
				show = {
					git = true,
				},
			},
		},
		filters = {
			dotfiles = false,
		},
	},
}

return M
