local M = {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local settings = require("configs.null-ls")
		null_ls.setup(settings)
	end,
}

return M
