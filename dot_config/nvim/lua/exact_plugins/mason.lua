-- Language Server Protocol (LSP) client configurations
local M = {
  "williamboman/mason.nvim",
  config = function()
    local opts = require "configs.mason"
    require("mason").setup(opts)
    local function MasonInstallAll()
      vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
    end

    vim.api.nvim_create_user_command("MasonInstallAll", MasonInstallAll, {})
  end,
}

return M
