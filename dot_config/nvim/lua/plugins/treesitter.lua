local M = { "nvim-treesitter/nvim-treesitter" }

M.branch = "main"
M.build = ":TSUpdate"
M.lazy = false

local MiB = 2 ^ 20
local max_filesize = 5 * MiB

---@param bufnr integer
---@return boolean
local function is_large_file(bufnr)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  return ok and stats ~= nil and stats.size > max_filesize
end

---@param lang string
---@return string[]
local function find_injection_languages(lang)
  local path = vim.api.nvim_get_runtime_file("queries/" .. lang .. "/injections.scm", false)[1]
  if not path then
    return {}
  end
  local content = io.open(path):read "*a"
  local langs = {}
  for injection_lang in content:gmatch 'injection%.language%s+"([%w_]+)"' do
    table.insert(langs, injection_lang)
  end
  return langs
end

---@param lang string
---@param installed table<string, boolean>
---@param ts table
local function ensure_parser(lang, installed, ts)
  if installed[lang] then
    return
  end
  local available = require "nvim-treesitter.parsers"
  if not available[lang] then
    return
  end

  installed[lang] = true
  ts.install { lang }

  local to_install = {}
  for _, injection_lang in ipairs(find_injection_languages(lang)) do
    if not installed[injection_lang] and available[injection_lang] then
      installed[injection_lang] = true
      table.insert(to_install, injection_lang)
    end
  end
  if #to_install > 0 then
    ts.install(to_install)
  end
end

function M.config()
  local ts = require "nvim-treesitter"
  local installed = {} ---@type table<string, boolean>
  for _, lang in ipairs(ts.get_installed()) do
    installed[lang] = true
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      if is_large_file(ev.buf) then
        return
      end
      local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
      ensure_parser(lang, installed, ts)
      pcall(vim.treesitter.start)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      if vim.bo.indentexpr == "" then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
