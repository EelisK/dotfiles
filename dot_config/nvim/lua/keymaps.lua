local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set
-- Function to toggle fold on current line
local function toggle_fold()
  local line = vim.fn.line "."
  local current_line_is_foldable = vim.fn.foldlevel(line) > 0
  if not current_line_is_foldable then
    return
  end
  local not_folded = vim.fn.foldclosed(line) == -1
  if not_folded then
    vim.cmd ":foldclose"
  else
    vim.cmd ":foldopen"
  end
end

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

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File operations
keymap("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
keymap("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })
keymap("n", "<leader>b", "<cmd>new<CR>", { desc = "general new buffer" })
keymap("n", "<leader>B", "<cmd>vnew<CR>", { desc = "general new buffer vertical" })
-- Open terminal
keymap("n", "<leader>tb", "<cmd>belowright split | terminal<CR>", { desc = "open terminal in new buffer" })
keymap("n", "<leader>tB", "<cmd>belowright vnew | terminal<CR>", { desc = "open terminal in new buffer vertical" })
-- Center current line
keymap("n", "n", "nzz", { desc = "next search result centered" })
keymap("n", "N", "Nzz", { desc = "previous search result centered" })
-- Replace current word
keymap(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "search and replace current word" }
)
-- Copy link to upstream version control
keymap("n", "<leader>gy", function()
  local absolute_path = vim.fn.expand "%:p"
  local current_line = vim.fn.line "."
  local blame_info =
    vim.fn.systemlist("git blame -L " .. current_line .. "," .. current_line .. " --porcelain " .. absolute_path)
  if blame_info == "" then
    return
  end

  -- Format eg. "1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0 4 1"
  local sha, original_line, _ = blame_info[1]:match "^(%S+)%s+(%d+)%s+(%d+)"
  if sha == nil or sha:match "^0+$" then
    -- uncommitted line
    vim.api.nvim_echo({
      { "Line is not committed yet", "WarningMsg" },
    }, false, {})
    return
  end

  -- get remote url
  local remote_url = vim.fn.systemlist("git config --get remote.origin.url")[1]

  -- Convert SSH URL to HTTPS URL if necessary
  if remote_url:match "^git@" then
    remote_url = remote_url:gsub(":", "/")
    remote_url = remote_url:gsub("^git@", "https://")
  end

  -- Remove .git suffix if present
  remote_url = remote_url:gsub("%.git$", "")

  -- Construct the URL to the specific line in the file
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local file_path = absolute_path:sub(#git_root + 2)
  local url = string.format("%s/blob/%s/%s#L%d", remote_url, sha, file_path, original_line)

  -- Copy the URL to the clipboard
  vim.fn.setreg("+", url)
  vim.api.nvim_echo({
    { "Copied to clipboard: " .. url, "Normal" },
  }, false, {})
end, { desc = "copy link to upstream version control" })

-- Folds
keymap("n", "zf", toggle_fold, { desc = "toggle fold on current line", remap = true })

-- Resize with arrows
keymap("n", "<A-Up>", ":resize +2<CR>", opts)
keymap("n", "<A-Down>", ":resize -2<CR>", opts)
keymap("n", "<A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Insert --
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
keymap("t", "<C-x>", "<C-\\><C-N>", term_opts)
keymap("t", "<Esc>", "<C-\\><C-N>", term_opts)

-- Comment
keymap("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
keymap("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Navigation on nordic layout
keymap({ "n", "v", "o" }, "€", "$", { desc = "Go to end of line" })
keymap({ "n", "v", "o" }, "¤", "$", { desc = "Go to end of line" })
