local M = {
	"mg979/vim-visual-multi",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.g.VM_maps["Get Operator"] = "<Leader>a"
		vim.g.VM_maps["Reselect Last"] = "<Leader>z"
		vim.g.VM_maps["Visual Cursors"] = "<Leader><Space>"
		vim.g.VM_maps["Undo"] = "u"
		vim.g.VM_maps["Redo"] = "<C-r>"
		vim.g.VM_maps["Visual Subtract"] = "zs"
		vim.g.VM_maps["Visual Reduce"] = "zr"
		-- vim.keymap.set("n", "<C-x>", "<Plug>(VM-Find-Under)")
	end,
}

return M
