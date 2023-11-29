---@type NvPluginSpec
local M = {
	"kdheepak/lazygit.nvim",
	lazy = false,
	requires = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").load_extension("lazygit")
	end,
}

return M
