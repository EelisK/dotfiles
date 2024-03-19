require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-t>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle nvimtree" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
map("n", "<leader>aa", "<cmd>FigCommentPrompt<cr>", { desc = "Create ascii art comment" })
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })
map("n", "<leader>fr", function()
	require("spectre").toggle()
end, { desc = "Toggle spectre" })
map("n", "<leader>tr", "<cmd>TroubleToggle<cr>", { desc = "Toggle trouble diagnostics" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

map({ "n", "v", "o" }, "€", "$", { desc = "Go to end of line" })
map({ "n", "v", "o" }, "¤", "$", { desc = "Go to end of line" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
