local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require "nvim-treesitter.configs"

    configs.setup {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "markdown",
        "markdown_inline",
        "toml",
        "bash",
        "python",
        "go",
        "rust",
        "java",
        "graphql",
        "hcl",
        "terraform",
        "bash",
        "markdown",
        "ninja",
        "ruby",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      auto_install = true,
    }
  end,
}

return M
