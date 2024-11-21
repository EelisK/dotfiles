local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  vim.notify "Failed to load cmp"
  return
end

local api = vim.api
local colors_icon = "󱓻 "
local fields = { "kind", "abbr", "menu" } -- { "abbr", "kind", "menu" }

local tailwind = function(entry, item)
  local entryItem = entry:get_completion_item()
  local color = entryItem.documentation

  if color and type(color) == "string" and color:match "^#%x%x%x%x%x%x$" then
    local hl = "hex-" .. color:sub(2)

    if #api.nvim_get_hl(0, { name = hl }) == 0 then
      api.nvim_set_hl(0, hl, { fg = color })
    end

    item.kind = colors_icon
    item.kind_hl_group = hl
    item.menu_hl_group = hl
  end
end

local options = {
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },

  formatting = {
    format = function(entry, item)
      local icons = require "icons.lspkind"

      item.abbr = item.abbr .. " "
      item.menu = item.kind or ""
      item.menu_hl_group = "LineNr" .. (item.kind or "") -- "CmpItemKind"
      item.kind = (icons[item.kind] or "") .. " "

      tailwind(entry, item)

      return item
    end,

    fields = fields,
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),

    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

return options
