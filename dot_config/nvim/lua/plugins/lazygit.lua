return {
  "kdheepak/lazygit.nvim",
  lazy = false,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  requires = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    -- override the default terminal mode keybinding
    -- to allow using <Esc> as configured in lazygit
    { "<Esc>", "<Esc>", mode = "t" },
  },
  config = function()
    require("telescope").load_extension "lazygit"
  end,
}
