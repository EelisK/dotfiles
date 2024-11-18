local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

require "options"
require "keymaps"
require "autocmds"
require "cmds"

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  vim.notify "Failed to load lazy.nvim"
  return
end

lazy.setup(require "plugins", require "configs.lazy")
