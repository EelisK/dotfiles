-- This is the main configuration file for Neovim.

if vim.fn.has "nvim-0.11" == 0 then
  vim.api.nvim_echo({
    { "This configuration requires Neovim 0.11 or higher.", "ErrorMsg" },
    { "Please update your Neovim installation.",            "ErrorMsg" },
  }, true, {})
  return
end

-- Load options and keymaps
require "options"
require "keymaps"

-- Load the lazy.nvim plugin manager
require "lazy_setup"

-- Load the core modules
require "commands"
require "autocmds"
require "lsp"
