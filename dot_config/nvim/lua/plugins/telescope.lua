return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = "Telescope",
  keys = {
    { "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" } },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" } },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" } },
    { "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" } },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" } },
    {
      "<leader>fz",
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      { desc = "telescope find in current buffer" },
    },
    { "<leader>fc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" } },
    { "<leader>fg", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" } },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" } },
    {
      "<leader>fa",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      { desc = "telescope find all files" },
    },
  },
  opts = {
    pickers = {
      colorscheme = {
        enable_preview = true,
      },
    },
    defaults = {
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = " ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      mappings = {
        n = { ["q"] = require("telescope.actions").close },
      },
    },

    extensions_list = { "themes" },
    extensions = {},
  },
}
