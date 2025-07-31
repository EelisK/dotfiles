---
--- https://github.com/golang/tools/tree/master/gopls
---
--- Google's lsp server for golang.

local mod_cache = nil

---@param fname string
---@return string?
local function get_root(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients { name = "gopls" }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, "go.work") or vim.fs.root(fname, "go.mod") or vim.fs.root(fname, ".git")
end

---@param bufnr number
---@param on_dir fun(dir: string?)
local function root_dir(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  -- see: https://github.com/neovim/nvim-lspconfig/issues/804
  if mod_cache then
    on_dir(get_root(fname))
    return
  end
  local cmd = { "go", "env", "GOMODCACHE" }
  vim.system(cmd, { text = true }, function(output)
    if output.code == 0 then
      if output.stdout then
        mod_cache = vim.trim(output.stdout)
      end
      on_dir(get_root(fname))
    else
      vim.notify(("[gopls] cmd failed with code %d: %s\n%s"):format(output.code, cmd, output.stderr))
    end
  end)
end

local function on_attach()
  local autoimport = vim.api.nvim_create_augroup("eelisk/lsp/gopls/autoimport", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function(event)
      local window = vim.api.nvim_get_current_win()
      local params = vim.lsp.util.make_range_params(window, "utf-8")

      ---@diagnostic disable-next-line: inject-field
      params.context = { only = { "source.organizeImports" } }
      local result = vim.lsp.buf_request_sync(event.buf, "textDocument/codeAction", params)
      for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
            vim.lsp.util.apply_workspace_edit(r.edit, enc)
          end
        end
      end
    end,
    group = autoimport,
  })
end

---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = root_dir,
  on_attach = on_attach,
  on_exit = function()
    vim.api.nvim_clear_autocmds { group = "eelisk/lsp/gopls/autoimport" }
  end,
}
