local M = { "hrsh7th/nvim-cmp" }

M.event = { "InsertEnter", "CmdlineEnter" }

M.enabled = true

M.dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "rafamadriz/friendly-snippets",
  {
    "garymjr/nvim-snippets", --> for expanding friendly_snippets
    opts = {
      friendly_snippets = true,
      create_cmp_source = true,
    },
  },
}

local colors_icon = "󱓻 "

local function tailwind(entry, item)
  local entryItem = entry:get_completion_item()
  local color = entryItem.documentation

  if color and type(color) == "string" and color:match "^#%x%x%x%x%x%x$" then
    local hl = "hex-" .. color:sub(2)

    if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
      vim.api.nvim_set_hl(0, hl, { fg = color })
    end

    item.kind = colors_icon
    item.kind_hl_group = hl
    item.menu_hl_group = hl
  end
end

M.config = function()
  local cmp = require "cmp"

  cmp.setup {
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },

    formatting = {
      format = function(entry, item)
        local icons = require("icons").lspkind

        item.abbr = item.abbr .. " "
        item.menu = item.kind or ""
        item.menu_hl_group = "LineNr" .. (item.kind or "") -- "CmpItemKind"
        item.kind = (icons[item.kind] or "") .. " "

        tailwind(entry, item)

        return item
      end,
    },

    -- UI customization
    window = {
      ---@diagnostic disable-next-line: undefined-field
      completion = cmp.config.window.bordered(),
      ---@diagnostic disable-next-line: undefined-field
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert {
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-e>"] = cmp.mapping.abort(),

      -- select = false: does nothing if nothing is selected (true would insert the first item)
      --[[ cmp.ConfirmBehavior.Replace:
      ("|" is the cursor)
      ```
                    |uire
                    ╭─────────────────────────────────╮
                    │ require(modname)  Function [LSP]│
                    │ req~           Snippet [LuaSnip]│

                    ... confirming the first item ...

                    require|
      ```
      If `behavior = cmp.confirmBehavior.Insert`, it would insert "requireuire"
      --]]
      ["<C-y>"] = cmp.mapping.confirm {
        select = false,
        behavior = cmp.ConfirmBehavior.Replace,
      },
      ["<CR>"] = cmp.mapping.confirm {
        select = false,
        behavior = cmp.ConfirmBehavior.Replace,
      },

      -- Scroll the doc [b]ack (down) / [f]orward (up)
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),

      -- Manually trigger the completion
      ["<C-Space>"] = cmp.mapping.complete {},

      -- Tab completion
      -- Cycle through the completion items if completion menu is visible
      -- Cycle through the snippet entries if applicable
      -- Else insert <TAB>
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.snippet.active { direction = 1 } then
          vim.snippet.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active { direction = -1 } then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    ---@diagnostic disable-next-line: undefined-field
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "snippets" },
      { name = "buffer" },
      { name = "path" },
    },
  }

  -- cmp-cmdline setup
  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = "cmdline" },
    },
  })
end

return M
