local M = { "folke/which-key.nvim" }

-- eager load on startup
M.lazy = false

M.keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" }

M.cmd = "WhichKey"

return M
