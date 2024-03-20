local M = {}

M.ui = {

  theme = "melange",

  nvdash = { load_on_startup = false },
  cheatsheet = { theme = "grid" },

  -- https://github.com/NvChad/base46/blob/v2.5/lua/base46/themes/melange.lua
  hl_override = {
    Comment = { italic = true },
    NvimTreeFolderName = { fg = "pmenu_bg" },
    NvimTreeEmptyFolderName = { fg = "pmenu_bg" },
    NvimTreeOpenedFolderName = { fg = "pmenu_bg" },
    NvimTreeFolderIcon = { fg = "pmenu_bg" },
    NvimTreeBookmarkIcon = { fg = "pmenu_bg" },
    NvimTreeGitFileIgnoredIcon = { fg = "one_bg3" },
    NvimTreeGitFileIgnoredHL = { fg = "one_bg3" },
  },

  tabufline = { show_numbers = false, enabled = true, lazyload = false },
  statusline = { theme = "vscode" },

  transparency = true,
}

return M
