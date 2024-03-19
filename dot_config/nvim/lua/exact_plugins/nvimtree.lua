-- File Explorer
local M = {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("configs.nvimtree")
	end,
}

return M
