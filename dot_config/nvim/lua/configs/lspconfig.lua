local M = {}
local map = vim.keymap.set
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local tactions = require "telescope.actions"
local taction_state = require "telescope.actions.state"
local conf = require("telescope.config").values

-- export on_attach & capabilities
local function on_attach(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")

  map("n", "<leader>lf", vim.diagnostic.open_float, opts "Open diagnostic float")
  map("n", "<leader>ld", vim.diagnostic.goto_prev, opts "Go to previous diagnostic")
  map("n", "<leader>ln", vim.diagnostic.goto_next, opts "Go to next diagnostic")
  map("n", "<leader>lq", vim.diagnostic.setloclist, opts "Set loclist")

  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")

  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "lsp.renamer", opts "Rename")
  map("n", "<leader>rc", function()
    local dropdown_opts = require("telescope.themes").get_dropdown {}
    local cases = { "camelCase", "snake_case", "kebab-case", "PascalCase", "MACRO_CASE" }
    local actions = {
      camelCase = "to_camel_case",
      snake_case = "to_snake_case",
      ["kebab-case"] = "to_kebab_case",
      PascalCase = "to_pascal_case",
      MACRO_CASE = "to_constant_case",
    }
    local textcase = require "textcase"
    pickers
      .new(dropdown_opts, {
        prompt_title = "Select case",
        finder = finders.new_table {
          results = cases,
        },
        sorter = conf.generic_sorter(dropdown_opts),
        attach_mappings = function(prompt_bufnr)
          tactions.select_default:replace(function()
            tactions.close(prompt_bufnr)
            local selection = taction_state.get_selected_entry()
            local case = selection[1]
            local action = actions[case]
            textcase.lsp_rename(action)
          end)
          return true
        end,
      })
      :find()
  end, opts "Change case")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- disable semanticTokens
local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

--

local border = {
  { "┌", "FloatBorder" },
  { "─", "FloatBorder" },
  { "┐", "FloatBorder" },
  { "│", "FloatBorder" },
  { "┘", "FloatBorder" },
  { "─", "FloatBorder" },
  { "└", "FloatBorder" },
  { "│", "FloatBorder" },
}

-- Add the border on hover and on signature help popup window
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

-- Add border to the diagnostic popup window
vim.diagnostic.config {
  virtual_text = {
    prefix = "■ ", -- Could be '●', '▎', 'x', '■', , 
  },
  float = { border = border },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lspconfig = require "lspconfig"

-- server_configurations.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local servers = { "html", "cssls", "ts_ls", "clangd", "bashls", "rubocop" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_init = on_init,
    handlers = handlers,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  on_init = on_init,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

lspconfig.pyright.setup {
  on_init = on_init,
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  -- configure virtual environments
  before_init = function(_, config)
    local Path = require "plenary.path"
    -- Try to find a virtualenv in the current directory (.venv, venv)
    local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
    if not venv:exists() then
      venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), "venv")
    end
    if venv:joinpath("bin"):is_dir() then
      config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
    else
      config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
    end
  end,

  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}

lspconfig.solargraph.setup {
  on_init = on_init,
  on_attach = on_attach,
  handlers = handlers,
  capabilities = capabilities,
  settings = {
    solargraph = {
      diagnostic = true,
    },
  },
}

lspconfig.rust_analyzer.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

lspconfig.metals.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  settings = {
    ["metals"] = {
      filetypes = { "sbt", "scala", "java" },
    },
  },
}

lspconfig.gopls.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

lspconfig.terraformls.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  filetypes = { "terraform", "tf" },
}

lspconfig.ansiblels.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  cmd = { "ansible-language-server", "--stdio" },
  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      ansible = {
        path = "ansible",
      },
      executionEnvironment = {
        enabled = false,
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint",
        },
      },
    },
  },
  filetypes = { "yaml.ansible" },
  root_dir = lspconfig.util.root_pattern("ansible.cfg", ".ansible-lint"),
  single_file_support = true,
}

return M
