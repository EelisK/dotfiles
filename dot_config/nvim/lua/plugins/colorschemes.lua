vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  desc = "Make all backgrounds transparent",
  group = vim.api.nvim_create_augroup("eelisk/colorscheme/nobg", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.o.background == "light" then
      return
    end
    local groups = {
      "Normal",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "BufferLineFill",
      "DiagnosticError",
      "Float",
      "NvimFloat",
      "DiagnosticFloatingError",
      "CocDiagnosticError",
      "NormalFloat",
    }
    -- trying to make the popup opaque
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = nil, ctermbg = nil })
    end
  end,
})

local theme_plugins = {
  {
    "savq/melange-nvim",
    lazy = false,
    keys = {
      {
        "<leader>th",
        function()
          vim.opt.background = vim.o.background == "dark" and "light" or "dark"
          vim.cmd "redraw"
        end,
        desc = "Toggle transparent background",
      },
    },
    config = function()
      vim.cmd.colorscheme "melange"
    end,
  },
}

return theme_plugins
