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
    tabufline = { show_numbers = false, enabled = true, lazyload = false },
    statusline = { theme = "vscode" },
    cmp = {
      icons_left = true, -- only for non-atom styles!
      lspkind_text = true,
      style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true, -- will work for css lsp too
        icon = "󱓻",
      },
    },
  },

  nvdash = {
    load_on_startup = false,
    header = {
      "  ███▄    █ ██▒   █▓ ██▓ ███▄ ▄███▓",
      "  ██ ▀█   █▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
      " ▓██  ▀█ ██▒▓██  █▒░▒██▒▓██    ▓██░",
      " ▓██▒  ▐▌██▒ ▒██ █░░░██░▒██    ▒██ ",
      " ▒██░   ▓██░  ▒▀█░  ░██░▒██▒   ░██▒",
      " ░ ▒░   ▒ ▒   ░ ▐░  ░▓  ░ ▒░   ░  ░",
      " ░ ░░   ░ ▒░  ░ ░░   ▒ ░░  ░      ░",
      "    ░   ░ ░     ░░   ▒ ░░      ░   ",
      "          ░      ░   ░         ░   ",
      "                ░                  ",
    },
    buttons = {
      { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
      { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        no_gap = false,
      },
    },
  },

  cheatsheet = { theme = "grid" },

  lsp = {
    signature = true,
  },

  mason = { cmd = true, pkgs = {} },
}
