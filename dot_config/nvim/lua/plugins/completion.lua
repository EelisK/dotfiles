local M = { "saghen/blink.cmp" }

M.event = { "BufReadPre", "BufNewFile" }

M.version = "1.*"

M.dependencies = {
  "rafamadriz/friendly-snippets",
  "nvim-tree/nvim-web-devicons",
  "onsails/lspkind-nvim",
}

M.opts = {
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },
  signature = { enabled = true },
  keymap = {
    preset = "enter",

    ["<Tab>"] = {
      "select_next",
      "snippet_forward",
      "fallback",
    },

    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      "fallback",
    },
  },

  -- sources = {
  --   providers = {
  --     lsp = {
  --       name = "LSP",
  --       module = "blink.cmp.sources.lsp",
  --       transform_items = function(_, items)
  --         return vim.tbl_filter(function(item)
  --           return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
  --         end, items)
  --       end,
  --     },
  --   },
  -- },
  completion = {

    -- 'prefix' will fuzzy match on the text before the cursor
    -- 'full' will fuzzy match on the text before _and_ after the cursor
    -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
    keyword = { range = "full" },

    -- Disable auto brackets
    -- NOTE: some LSPs may add auto brackets themselves anyway
    accept = { auto_brackets = { enabled = false } },
    documentation = {
      auto_show = true,
      window = {
        border = "rounded",
      },
    },

    menu = {
      auto_show = true,
      border = "rounded",
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require("lspkind").symbolic(ctx.kind, {
                  mode = "symbol",
                })
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
        },
      },
    },
  },
}

return M
