local cmd = vim.api.nvim_create_user_command

cmd("Q", function()
  vim.cmd "qa"
end, { desc = "Close all buffers and exit" })

cmd("ColorSchemeToggle", function()
  vim.opt.background = vim.o.background == "dark" and "light" or "dark"
end, {
  desc = "Toggle between light and dark color schemes",
})

cmd("SetCase", function(args)
  local case = args.args
  local word = vim.fn.expand "<cword>"
  if word == "" then
    print "No word under cursor"
    return
  end

  local textcase = require "textcase"
  local converted = textcase.convert(word, case)

  if converted then
    vim.cmd(string.format("normal ciw%s", converted))
  else
    print("Invalid case: " .. case)
  end
end, {
  desc = "Set the case of the current word",
  nargs = 1,
  complete = function()
    return {
      "snake_case",
      "camelCase",
      "PascalCase",
      "kebab-case",
      "MACRO_CASE",
    }
  end,
})

cmd("Scratch", function()
  vim.cmd "bel 10new"
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs {
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  } do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer", nargs = 0 })
