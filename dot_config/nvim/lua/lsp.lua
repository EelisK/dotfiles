-- LSP configuration using the built-in LSP client
--
--  ██▓      ██████  ██▓███
-- ▓██▒    ▒██    ▒ ▓██░  ██▒
-- ▒██░    ░ ▓██▄   ▓██░ ██▓▒
-- ▒██░      ▒   ██▒▒██▄█▓▒ ▒
-- ░██████▒▒██████▒▒▒██▒ ░  ░
-- ░ ▒░▓  ░▒ ▒▓▒ ▒ ░▒▓▒░ ░  ░
-- ░ ░ ▒  ░░ ░▒  ░ ░░▒ ░
--   ░ ░   ░  ░  ░  ░░
--     ░  ░      ░
--

---@return string[]
local function get_lsp_servers()
  local lsp_dir = vim.fn.stdpath "config" .. "/lsp"
  local lsp_servers = {}

  if vim.fn.isdirectory(lsp_dir) == 1 then
    for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
      if file:match "%.lua$" and file ~= "init.lua" then
        local server_name = file:gsub("%.lua$", "")
        table.insert(lsp_servers, server_name)
      end
    end
  end

  return lsp_servers
end

-- Neovim will call config() for the merged tables in `nvim/lsp/<name>.lua` as well as explicit calls
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

-- Configuring keymaps and autocmd for LSP buffers
local on_attach = function(event)
  local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
  -- Create a shortcut for checkhealth
  vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { nargs = 0 })

  -- Helper function for creating LSP keybindings
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "[LSP] " .. desc })
  end

  -- settings and mapping sfor the diagnostic framework
  vim.diagnostic.config {
    virtual_lines = { current_line = true },
    float = {
      border = "rounded",
    },
    virtual_text = { prefix = "" },
    signs = {
      text = require("icons").diagnostic.text,
    },
    underline = true,
    update_in_insert = false,
  }

  -- settings for the LSP framework
  map("<leader>fm", vim.lsp.buf.format, "Format buffer")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gi", vim.lsp.buf.implementation, "Go to implementation")

  map("<leader>sh", vim.lsp.buf.signature_help, "Show signature help")
  map("K", vim.lsp.buf.hover, "Hover")

  map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

  map("<leader>D", vim.lsp.buf.type_definition, "Go to type definition")
  map("<leader>ra", function()
    local api = vim.api
    local var = vim.fn.expand "<cword>"
    local buf = api.nvim_create_buf(false, true)
    local opts = { height = 1, style = "minimal", border = "single", row = 1, col = 1 }

    opts.relative, opts.width = "cursor", #var + 15
    opts.title, opts.title_pos = { { " Renamer ", "@comment.danger" } }, "center"

    local win = api.nvim_open_win(buf, true, opts)
    vim.wo[win].winhl = "Normal:Normal,FloatBorder:Removed"
    api.nvim_set_current_win(win)

    api.nvim_buf_set_lines(buf, 0, -1, true, { " " .. var })
    vim.api.nvim_input "A"

    vim.keymap.set({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = buf })

    vim.keymap.set("i", "<CR>", function()
      local newName = vim.trim(api.nvim_get_current_line())
      api.nvim_win_close(win, true)

      if #newName > 0 and newName ~= var then
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        ---@diagnostic disable-next-line: inject-field
        params.newName = newName
        vim.lsp.buf_request(0, "textDocument/rename", params)
      end

      vim.cmd.stopinsert()
    end, { buffer = buf })
  end, "Rename")

  -- diagnostic mappings
  map("<leader>lf", vim.diagnostic.open_float, "Open diagnostic float")
  map("<leader>ld", function()
    vim.diagnostic.jump { count = -1, float = true }
  end, "Go to previous diagnostic")
  map("<leader>ln", function()
    vim.diagnostic.jump { count = 1, float = true }
  end, "Go to next diagnostic")
  map("<leader>lq", vim.diagnostic.setloclist, "Open diagnostic Quickfix list")

  -- Symbol highlights
  -- Creates an autocmd to highlight the symbol under the cursor
  if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
    local lsp_hl_group = vim.api.nvim_create_augroup("eelisk.lsp.hl", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      group = lsp_hl_group,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      group = lsp_hl_group,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("eelisk.lsp.hl_detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = "eelisk.lsp.hl", buffer = event2.buf }
      end,
    })
  end

  -- Integration with the built-in completion
  if client:supports_method "textDocument/completion" then
    vim.lsp.completion.enable(true, client.id, event.buf, {
      autotrigger = true,
    })
  end

  -- Auto-format ("lint") on save.
  -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
  if
    not client:supports_method "textDocument/willSaveWaitUntil" and client:supports_method "textDocument/formatting"
  then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
      buffer = event.buf,
      callback = function()
        vim.lsp.buf.format { bufnr = event.buf, id = client.id, timeout_ms = 1000 }
      end,
    })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("eelisk.lsp", { clear = true }),
  callback = on_attach,
})

-- Enable the servers!
vim.lsp.enable(get_lsp_servers())
