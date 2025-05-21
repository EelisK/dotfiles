-- Vim filetype plugin file
-- Language:    C++

vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.colorcolumn = "80"
vim.opt_local.textwidth = 79
vim.opt_local.matchpairs:append "=:;"

-- This command is to compile and run a single C++ file using g++.
-- For more complex project (that is, any project with more than one .cc file),
-- you should consider making a Makefile and use `:make` command
vim.api.nvim_create_user_command("RunCpp", "!g++ %:p -Wall -Werror -std=c++11 -o %:p:r && %:p:r", { bang = true })
