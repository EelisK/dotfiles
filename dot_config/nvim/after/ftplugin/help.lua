-- Vim filetype plugin file
-- Language:    Help

vim.opt_local.bufhidden = "unload"

local map = vim.keymap.set
local opts = { buffer = true }

-- Better navigation.
-- https://vim.fandom.com/wiki/Learn_to_use_help#Simplify_help_navigation
map("n", "<cr>", "<c-]>", opts)
map("n", "<bs>", "<c-T>", opts)
