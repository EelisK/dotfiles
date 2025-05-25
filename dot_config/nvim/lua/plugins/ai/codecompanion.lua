---@brief
--- LLM development tool for Neovim
---
--- Chat variables:
---
--- `#buffer`: Shares the current buffer's code. This can also receive parameters
--- `#lsp`: Shares LSP information and code for the current buffer
--- `#viewport`: Shares the buffers and lines that you see in the Neovim viewport
---
--- Slash commands:
--- `/buffer` - Insert open buffers
--- `/fetch` - Insert URL contents
--- `/file` - Insert file contents
--- `/help` - Insert content from help tags
--- `/now` - Insert current date and time
--- `/symbols` - Insert symbols from a selected file
--- `/terminal` - Insert terminal output
---
--- Agents / Tools:
---
--- `@cmd_runner`: The LLM will run shell commands (subject to approval)
--- `@editor`: The LLM will edit code in a Neovim buffer
--- `@files`: The LLM will can work with files on the file system (subject to approval)
--- `@full_stack_dev`: Contains `@cmd_runner`, `@editor`, and `@files` tools
---
--- [codecompanion.olimorris.dev](https://codecompanion.olimorris.dev/)
local M = { "olimorris/codecompanion.nvim" }

M.opts = function()
  return {
    strategies = {
      -- default chat adapter
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
      actions = {
        adapter = "copilot",
      },
    },
    opts = {
      ---@type 'TRACE' | 'DEBUG' | 'INFO' | 'ERROR'
      log_level = "ERROR",
      language = "English",
      -- send_code = true,
    },
  }
end

M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "codecompanion" },
  },
}

-- Use '<leader>cc' as the prefix for all keymaps
local prefix = "<leader>cc"
M.keys = {
  { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "(AI) Action Palette" },
  { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "(AI) New Chat" },
  { prefix .. "A", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "(AI) Add Code" },
  { prefix .. "i", "<cmd>CodeCompanion<cr>", mode = "n", desc = "(AI) Inline Prompt" },
  { prefix .. "C", "<cmd>CodeCompanionToggle<cr>", mode = "n", desc = "(AI) Toggle Chat" },
}

return M
