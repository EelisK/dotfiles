-- Binary file reader for Neovim using xxd and file
--
--  ██░ ██ ▓█████ ▒██   ██▒
-- ▓██░ ██▒▓█   ▀ ▒▒ █ █ ▒░
-- ▒██▀▀██░▒███   ░░  █   ░
-- ░▓█ ░██ ▒▓█  ▄  ░ █ █ ▒
-- ░▓█▒░██▓░▒████▒▒██▒ ▒██▒
--  ▒ ░░▒░▒░░ ▒░ ░▒▒ ░ ░▓ ░
--  ▒ ░▒░ ░ ░ ░  ░░░   ░▒ ░
--  ░  ░░ ░   ░    ░    ░
--  ░  ░  ░   ░  ░ ░    ░
--

if vim.fn.executable "xxd" == 0 then
  return
end

if vim.fn.executable "file" == 0 then
  return
end

local group = vim.api.nvim_create_augroup("eelisk/hex", { clear = true })
local converter = require "hex.converter"

--------------------------------
--       Autocommands         --
--------------------------------
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = group,
  callback = function()
    local file_output = vim.fn.systemlist('file --brief --mime-encoding "' .. vim.fn.expand "%:p" .. '"')
    if file_output[1] == "binary" then
      converter:dump()
    end
  end,
})

--------------------------------
--         Commands           --
--------------------------------
vim.api.nvim_create_user_command("HexDump", function()
  if vim.b.hex then
    vim.api.nvim_echo({ { "Buffer is already in hex mode!", "WarningMsg" } }, false, {})
    return
  end
  converter:dump()
end, {})

vim.api.nvim_create_user_command("HexAssemble", function()
  if not vim.b.hex then
    vim.api.nvim_echo({ { "Buffer is not in hex mode!", "WarningMsg" } }, false, {})
    return
  end
  converter:assemble()
end, {})
vim.api.nvim_create_user_command("HexToggle", function()
  if vim.b.hex then
    converter:assemble()
  else
    converter:dump()
  end
end, {})
