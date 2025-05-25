local M = { "github/copilot.vim" }

M.event = "User FilePost"

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

M.config = function()
  vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  vim.api.nvim_set_keymap("i", "<C-O>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end

return M
