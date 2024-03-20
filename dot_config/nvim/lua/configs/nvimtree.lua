local nvchad_options = require "nvchad.configs.nvimtree"
local nvim_tree = require "nvim-tree"

local nvchad_overrides = {
  git = {
    enable = true,
    ignore = false,
  },

  filters = {
    dotfiles = false,
  },
  renderer = {
    special_files = {},
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = false,
        git = true,
      },
      glyphs = {
        symlink = "",
        folder = {
          default = "",
          open = "",
          symlink = "",
        },
      },
    },
  },
}
local options = vim.tbl_deep_extend("force", nvchad_options, nvchad_overrides)
nvim_tree.setup(options)

vim.cmd [[
  hi NvimTreeFolderName guifg=#8f8f8f
  hi NvimTreeEmptyFolderName guifg=#8f8f8f
  hi NvimTreeOpenedFolderName guifg=#8f8f8f
  hi NvimTreeFolderIcon guifg=#8f8f8f
  hi NvimTreeBookmarkIcon guifg=#8f8f8f
  hi NvimTreeGitFileIgnoredIcon guifg=#656565
  hi NvimTreeGitFileIgnoredHL guifg=#656565
]]
