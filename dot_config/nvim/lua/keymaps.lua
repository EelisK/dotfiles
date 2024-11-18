local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File operations
keymap("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
keymap("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- global lsp mappings
keymap("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
keymap("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
keymap("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
keymap("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Navigate buffers
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Insert --
keymap("i", "jk", "<ESC>", opts)
keymap("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
keymap("i", "<C-e>", "<End>", { desc = "move end of line" })
keymap("i", "<C-h>", "<Left>", { desc = "move left" })
keymap("i", "<C-l>", "<Right>", { desc = "move right" })
keymap("i", "<C-j>", "<Down>", { desc = "move down" })
keymap("i", "<C-k>", "<Up>", { desc = "move up" })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- Delete text without copying it
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
keymap("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- Comment
keymap("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
keymap("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
