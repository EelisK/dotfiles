local M = {
  "pavanbhat1999/figlet.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- comment support
    "numToStr/Comment.nvim",
  },
}

return M
