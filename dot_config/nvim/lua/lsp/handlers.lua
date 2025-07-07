local M = {}

local m = vim.lsp.protocol.Methods

---@param event vim.api.keyset.create_autocmd.callback_args
function M.on_attach(event)
  local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
  ---@param method string
  ---@return boolean
  local function supports(method)
    return client:supports_method(method)
  end

  -- Create a shortcut for checkhealth
  vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { nargs = 0 })
  -- Create a shortcut for restarting the LSP client
  vim.api.nvim_create_user_command("LspRestart", function()
    local clients = vim.lsp.get_clients { bufnr = event.buf }
    for _, c in pairs(clients) do
      vim.lsp.enable(c.name, false)
    end
    ---@diagnostic disable-next-line: undefined-field
    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for _, c in ipairs(clients) do
        vim.schedule_wrap(function(x)
          vim.lsp.enable(x)
        end)(c.name)
      end
    end)
  end, { nargs = 0, desc = "Restart LSP client" })
  -- Create a shortcut for showing the LSP client logs
  vim.api.nvim_create_user_command("LspLogs", function()
    local log_path = vim.lsp.get_log_path()
    if log_path then
      vim.cmd("edit " .. log_path)
    else
      vim.notify("No LSP logs found", vim.log.levels.WARN)
    end
  end, { nargs = 0, desc = "Show LSP logs" })

  -- Helper function for creating LSP keybindings
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = "[LSP] " .. desc, buffer = event.buf, silent = true })
  end

  if supports(m.workspace_symbol) then
    map("<leader>ws", vim.lsp.buf.workspace_symbol, "workspace symbols")
  end
  if supports(m.textDocument_codeAction) then
    map("<leader>ca", vim.lsp.buf.code_action, "code actions")
  end
  if supports(m.textDocument_codeLens) then
    map("<leader>clr", vim.lsp.codelens.run, "code lens")
    map("<leader>cll", vim.lsp.codelens.refresh, "code lens refresh")
  end
  if supports(m.textDocument_diagnostic) then
    map("<leader>dl", vim.diagnostic.setloclist, "diagnostic loclist")
  end
  if supports(m.textDocument_incomingCalls) then
    map("<leader>ci", vim.lsp.buf.incoming_calls, "incoming calls")
  end
  if supports(m.textDocument_documentSymbol) then
    map("gs", vim.lsp.buf.document_symbol, "document symbols")
  end
  if supports(m.textDocument_declaration) then
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
  end
  if supports(m.textDocument_definition) then
    map("gd", vim.lsp.buf.definition, "Go to definition")
  end
  if supports(m.textDocument_implementation) then
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
  end
  if supports(m.textDocument_references) then
    map("gr", vim.lsp.buf.references, "Go to references")
  end
  if supports(m.textDocument_hover) then
    map("K", vim.lsp.buf.hover, "Hover")
  end
  if supports(m.textDocument_typeDefinition) then
    map("<leader>gt", vim.lsp.buf.type_definition, "Go to type definition")
  end
  if supports(m.textDocument_rename) then
    map("<leader>ra", require "lsp.actions.renamer", "Rename")
  end
  -- Integration with the built-in completion
  if supports(m.textDocument_completion) then
    vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
  end
  -- Use LSP folding if supported
  if supports(m.textDocument_foldingRange) then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end

  -- diagnostic mappings
  map("<leader>lf", vim.diagnostic.open_float, "Open diagnostic float")
  map("<leader>ld", function()
    vim.diagnostic.jump { count = -1, float = true }
  end, "Go to previous diagnostic")
  map("<leader>ln", function()
    vim.diagnostic.jump { count = 1, float = true }
  end, "Go to next diagnostic")

  -- Symbol highlights
  -- Creates an autocmd to highlight the symbol under the cursor
  if supports(m.textDocument_documentHighlight) then
    local lsp_hl_group = vim.api.nvim_create_augroup("eelisk/lsp/hl", { clear = false })
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
      group = vim.api.nvim_create_augroup("eelisk/lsp/hl_detach", { clear = true }),
      callback = function(args)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = "eelisk/lsp/hl", buffer = args.buf }
      end,
    })
  end

  -- Auto-format ("lint") on save.
  -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
  if
    not client:supports_method(m.textDocument_willSaveWaitUntil) and client:supports_method(m.textDocument_formatting)
  then
    -- disable auto-format by default
    vim.g.disable_lsp_autoformat = true
    vim.api.nvim_create_user_command("LspFormat", function()
      vim.lsp.buf.format { bufnr = event.buf, id = client.id, timeout_ms = 1000 }
    end, { desc = "Format buffer" })

    vim.api.nvim_create_user_command("LspFormatDisable", function(args)
      if args.bang then
        vim.b.disable_lsp_autoformat = true
      else
        vim.g.disable_lsp_autoformat = true
      end
    end, { desc = "(LSP) Disable auto-format on save" })

    vim.api.nvim_create_user_command("LspFormatEnable", function()
      vim.b.disable_lsp_autoformat = false
      vim.g.disable_lsp_autoformat = false
    end, { desc = "(LSP) Enable auto-format on save" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("eelisk/lsp/fmt", { clear = false }),
      buffer = event.buf,
      callback = function(args)
        if vim.b.disable_lsp_autoformat or vim.g.disable_lsp_autoformat then
          vim.notify("Auto-formatting is disabled for this buffer.", vim.log.levels.INFO, { title = "eelisk/lsp" })
          return
        end
        vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
      end,
    })
  end
end

-- LSP capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
-- Enable folding capabilities
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
-- Enable multiline semantic tokens
M.capabilities.textDocument = vim.tbl_deep_extend("force", M.capabilities.textDocument, {
  semanticTokens = {
    multilineTokenSupport = true,
  },
})

return M
