-- Vim filetype plugin file
-- Language:    Python

vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4

-- Command to run the current file
vim.api.nvim_create_user_command("RunPython", "!python %:p", { bang = true })
