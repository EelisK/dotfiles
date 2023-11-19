local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- server_configurations.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- if you want to override the default config then use the setup function
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- configure virtual environments
  before_init = function(_, config)
    local Path = require "plenary.path"
    local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
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
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    solargraph = {
      diagnostic = true,
    },
  },
}

lspconfig.rubocop.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "terraform", "tf" },
}

lspconfig.ansiblels.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
