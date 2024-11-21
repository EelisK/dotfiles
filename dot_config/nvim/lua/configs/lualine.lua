local lualine = require "lualine"

local predetermined_colors = {
  dark = "#303030",
  neutral = "#505050",
  light = "#707070",
  transparent = "transparent",
}

local separators = require "icons.separators"

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  buffer_has_lsp = function()
    return next(vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }) ~= nil
  end,
}

-- Config
local config = {
  disabled_filetypes = {
    "packer",
    "NVimTree",
    "neo-tree",
    "neo-tree-popup",
  },
  options = {
    -- Customize the theme here
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = predetermined_colors.dark, bg = predetermined_colors.transparent } },
      inactive = { c = { fg = predetermined_colors.dark, bg = predetermined_colors.transparent } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local function dynamic_color()
  -- auto change color according to neovims mode
  local colorscheme = vim.api.nvim_get_color_map()
  local function to_hex_str(color)
    return string.format("#%06x", colorscheme[color])
  end
  local mode_color = {
    i = to_hex_str "Yellow",
    v = to_hex_str "Violet",
    [""] = to_hex_str "Violet",
    V = to_hex_str "Violet",

    n = predetermined_colors.light,
    c = predetermined_colors.light,
    no = predetermined_colors.light,
    s = predetermined_colors.light,
    S = predetermined_colors.light,
    [""] = predetermined_colors.light,
    ic = predetermined_colors.light,
    R = predetermined_colors.light,
    Rv = predetermined_colors.light,
    cv = predetermined_colors.light,
    ce = predetermined_colors.light,
    r = predetermined_colors.light,
    rm = predetermined_colors.light,
    ["r?"] = predetermined_colors.light,
    ["!"] = predetermined_colors.light,
    t = predetermined_colors.light,
  }
  return mode_color[vim.fn.mode()]
end

ins_left {
  -- mode component
  "mode",
  color = function()
    return { fg = predetermined_colors.dark, bg = dynamic_color() }
  end,
  padding = { right = 0, left = 1 },
}
ins_left {
  function()
    return separators.right
  end,
  color = function()
    return { fg = dynamic_color(), bg = predetermined_colors.transparent }
  end,
  padding = { left = 0 },
}
ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = predetermined_colors.light },
}
ins_left {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = { fg = predetermined_colors.light },
    warn = { fg = predetermined_colors.light },
    info = { fg = predetermined_colors.light },
  },
}

-- Insert mid section. You can make any number of sections in neovim
-- for lualine it's any number greater than 2
ins_left {
  function()
    return "%="
  end,
}
ins_left {
  function()
    return require("lsp-progress").progress()
  end,
  cond = conditions.buffer_has_lsp,
  color = { fg = predetermined_colors.light },
}

ins_right {
  "diff",
  symbols = { added = " ", modified = "󰝤 ", removed = " " },
  diff_color = {
    added = { fg = predetermined_colors.light },
    modified = { fg = predetermined_colors.light },
    removed = { fg = predetermined_colors.light },
  },
  cond = conditions.hide_in_width,
}
ins_right { "location", color = { fg = predetermined_colors.light } }
ins_right { "progress", color = { fg = predetermined_colors.light } }
ins_right {
  function()
    return separators.left
  end,
  color = { fg = predetermined_colors.light },
  padding = { right = 0 },
}
ins_right {
  "branch",
  icon = "",
  color = { bg = predetermined_colors.light, fg = predetermined_colors.dark },
}
ins_right {
  function()
    return "▊"
  end,
  color = { fg = predetermined_colors.light }, -- Sets highlighting of component
  padding = { left = 0, right = 0 }, -- We don't need space before this
}

-- initialize lsp-progress
require("lsp-progress").setup()
-- initialize lualine
lualine.setup(config)

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})

return config
