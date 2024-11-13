local M = {
  "github/copilot.vim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_assume_mapped = true
    vim.api.nvim_set_keymap("i", "<C-O>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}

return M
