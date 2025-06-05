--- Configure Neovim built-in Treesitter engine

local M = { "nvim-treesitter/nvim-treesitter" }

M.build = ":TSUpdate"

M.main = "nvim-treesitter.configs"

M.opts = {
  auto_install = true,
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "comment",
  },

  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 5 * 1e6 -- 5 MB
      ---@diagnostic disable: undefined-field
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  indent = {
    enable = true,
  },
}

return M
