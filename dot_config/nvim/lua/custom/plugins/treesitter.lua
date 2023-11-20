-- Syntax Highlighting

---@type NvPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  opts = {
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

    indent = {
      enable = true,
    },
    auto_install = true,
  },
}

return M
