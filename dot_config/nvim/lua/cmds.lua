local cmd = vim.api.nvim_create_user_command

cmd("Q", function()
  vim.cmd "qa"
end, {
  desc = "Close all buffers and exit",
})

cmd("FigCommentPrompt", function()
  vim.ui.input({
    prompt = "Comment: ",
  }, function(value)
    vim.cmd("FigComment " .. value)
  end)
end, {
  desc = "Prompt for an input",
})

cmd("ColorSchemeToggle", function()
  if vim.o.background == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
end, {
  desc = "Toggle between light and dark color schemes",
})
