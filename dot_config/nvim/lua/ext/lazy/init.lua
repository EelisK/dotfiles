local config = require "ext.lazy.config"
local lazypath = config.root .. "/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { ("Unable to clone lazy from: %s\n"):format(repo), "ErrorMsg" },
      { "Press any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")

-- Check if lazy.nvim is loaded successfully
if not lazy_ok then
  vim.api.nvim_echo({
    { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" },
    { "Press any key to exit...", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

-- Load the configuration for lazy.nvim
lazy.setup(config)
