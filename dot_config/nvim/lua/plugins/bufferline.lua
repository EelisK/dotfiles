return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "famiu/bufdelete.nvim",
      cmd = { "Bdelete", "Bwipeout" },
    },
  },
  keys = {
    { "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "bufferline next" } },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "bufferline prev" } },
    { "<leader>x", "<cmd>Bdelete<CR>", { desc = "bufferline close current" } },
    { "<leader>X", "<cmd>Bwipeout<CR>", { desc = "bufferline clear others" } },
  },
  config = function()
    local bufferline = require "bufferline"

    local M = {}

    M.options = {
      mode = "buffers", -- set to "tabs" to only show tabpages instead
      style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
      themable = false, -- true | false, -- allows highlight groups to be overridden i.e. sets highlights as default
      numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      close_command = require("bufdelete").bufdelete,
      right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
      indicator = {
        style = "none", -- | "underline" | "none",
      },
      buffer_close_icon = "󰅖",
      modified_icon = "● ",
      close_icon = " ",
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      truncate_names = true, -- whether or not tab names should be truncated
      tab_size = 18,
      diagnostics = false, -- false | "nvim_lsp" | "coc",
      diagnostics_update_in_insert = false, -- only applies to coc
      diagnostics_update_on_event = true, -- use nvim's diagnostic handler
      -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return "(" .. count .. ")"
      end,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer", -- | function ,
          text_align = "left", -- "left" | "center" | "right"
          separator = true,
        },
        {
          filetype = "neo-tree",
          text = "File Explorer", -- | function ,
          text_align = "left", -- "left" | "center" | "right"
          separator = true,
        },
        {
          filetype = "Dap",
          text = "Debugger", -- | function ,
          text_align = "left", -- "left" | "center" | "right"
          separator = true,
        },
      },
      color_icons = true, -- | false, -- whether or not to add the filetype icon highlights
      get_element_icon = function(element)
        -- element consists of {filetype: string, path: string, extension: string, directory: string}
        -- This can be used to change how bufferline fetches the icon
        -- for an element e.g. a buffer or a tab.
        -- e.g.
        local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
        return icon, hl
      end,
      show_buffer_icons = true, -- | false, -- disable filetype icons for buffers
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true, -- | false,
      show_duplicate_prefix = true, -- | false, -- whether to show duplicate buffer prefix
      duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false, -- | true,
      always_show_bufferline = true, -- | false,
      auto_toggle_bufferline = true, -- | false,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      sort_by = "insert_after_current", -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
      -- add custom logic
      --     local modified_a = vim.fn.getftime(buffer_a.path)
      --     local modified_b = vim.fn.getftime(buffer_b.path)
      --     return modified_a > modified_b
      -- end
    }

    -- Function to close empty and unnamed buffers
    local function close_empty_unnamed_buffers()
      -- Get a list of all buffers
      local buffers = vim.api.nvim_list_bufs()

      -- Iterate over each buffer
      for _, bufnr in ipairs(buffers) do
        -- Check if the buffer is empty and doesn't have a name
        if
          vim.api.nvim_buf_is_loaded(bufnr)
          and vim.api.nvim_buf_get_name(bufnr) == ""
          and vim.api.nvim_get_option_value("buftype", {
            buf = bufnr,
          }) == ""
        then
          -- Get all lines in the buffer
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

          -- Initialize a variable to store the total number of characters
          local total_characters = 0

          -- Iterate over each line and calculate the number of characters
          for _, line in ipairs(lines) do
            total_characters = total_characters + #line
          end

          -- Close the buffer if it's empty:
          if total_characters == 0 then
            vim.api.nvim_buf_delete(bufnr, {
              force = true,
            })
          end
        end
      end
    end

    -- Clear the mandatory, empty, unnamed buffer when a real file is opened:
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      pattern = "*",
      callback = close_empty_unnamed_buffers,
    })

    bufferline.setup(M)
  end,
}
