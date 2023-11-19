-- Language Server Protocol (LSP) setup
-- with nvim-lspconfig and null-ls.nvim

---@type NvPluginSpec
local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- format & linting
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
  },
  config = function()
    require "plugins.configs.lspconfig"
    require "custom.configs.lsp"
  end, -- Override to setup mason-lspconfig
}

return M
