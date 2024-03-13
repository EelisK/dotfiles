-- Language Server Protocol (LSP) setup with nvim-lspconfig

local M = {
	"neovim/nvim-lspconfig",
	config = function()
		require("nvchad.configs.lspconfig").defaults()
		require("configs.lsp")
	end, -- Override to setup mason-lspconfig
}

return M
