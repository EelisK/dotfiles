---@type LazyConfig
---@diagnostic disable-next-line: missing-fields
local config = {
  root = vim.fn.stdpath "data" .. "/lazy", -- plugin installation directory
  defaults = { lazy = true },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "melange" },
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  spec = {
    { import = "plugins" },
    { import = "plugins.ai" },
  },
}

local lazypath = config.root .. "/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
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
