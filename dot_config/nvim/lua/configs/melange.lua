local colorscheme = "melange"

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  desc = "Make all backgrounds transparent",
  group = vim.api.nvim_create_augroup("nobg", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.o.background == "light" then
      return
    end
    local groups = {
      "Normal",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "BufferLineFill",
      "DiagnosticError",
      "Float",
      "NvimFloat",
      "DiagnosticFloatingError",
      "CocDiagnosticError",
      "NormalFloat",
    }
    -- trying to make the popup opaque
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = nil, ctermbg = nil })
    end
  end,
})

vim.api.nvim_create_user_command("ColorSchemeToggle", function()
  if vim.o.background == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
  vim.cmd.colorscheme(colorscheme)
end, {
  desc = "Toggle between light and dark color schemes",
})
vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>ColorSchemeToggle<CR>", { noremap = true, silent = true })

-- set colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme(colorscheme)
