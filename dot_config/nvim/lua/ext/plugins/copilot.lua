return {
  {
    "github/copilot.vim",
    event = "User FilePost",
    config = function()
      vim.g.copilot_no_tab_map = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
      vim.api.nvim_set_keymap("i", "<C-O>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- for telescope integration
    },
    opts = {
      debug = false,
      window = {
        layout = "horizontal",
        relative = "cursor",
      },
    },
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input "Ask copilot : "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>ccp",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>cch",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      {
        "<leader>cco",
        function()
          require("CopilotChat").open()
        end,
        desc = "CopilotChat - Open chat",
      },
    },
  },
}
