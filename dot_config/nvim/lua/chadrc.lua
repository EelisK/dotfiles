return {
  base46 = {
    theme = "melange",
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
    transparency = true,
    theme_toggle = { "onedark", "one_light" },
    changed_themes = {},
  },

  ui = {
    nvdash = { load_on_startup = false },
    tabufline = { show_numbers = false, enabled = true, lazyload = false },
    statusline = { theme = "vscode" },
  },

  cheatsheet = { theme = "grid" },

  lsp = {
    signature = true,
  },

  mason = { cmd = true, pkgs = {} },
}
