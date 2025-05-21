local cmd = vim.api.nvim_create_user_command

cmd("Q", function()
  vim.cmd "qa"
end, { desc = "Close all buffers and exit" })

cmd("ColorSchemeToggle", function()
  vim.opt.background = vim.o.background == "dark" and "light" or "dark"
end, {
  desc = "Toggle between light and dark color schemes",
})
