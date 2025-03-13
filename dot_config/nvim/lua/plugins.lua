---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

local M = {
  -- Utilities
  "nvim-lua/plenary.nvim",

  -- UI stuff
  {
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
    opts = function()
      return require "configs.bufferline"
    end,
  },

  {
    "savq/melange-nvim",
    lazy = false,
    config = function()
      vim.cmd.colorscheme "melange"
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "linrongbin16/lsp-progress.nvim" },
    },
    opts = function()
      return require "configs.lualine"
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    config = function()
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    opts = function()
      return require "configs.markview"
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "davidmh/mdx.nvim",
    config = true,
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- file managing , picker etc
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
      "mrbjarksen/neo-tree-diagnostics.nvim",
    },
    keys = {
      {
        "<C-t>",
        function()
          require("neo-tree.command").execute { toggle = true }
        end,
        desc = "Toggle NeoTree",
      },
    },
    opts = function()
      return require "configs.neo-tree"
    end,
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    keys = {
      -- telescope
      { "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" } },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" } },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" } },
      { "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" } },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" } },
      {
        "<leader>fz",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        { desc = "telescope find in current buffer" },
      },
      { "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" } },
      { "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" } },
      { "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" } },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" } },
      {
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        { desc = "telescope find all files" },
      },
    },
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    keys = {},
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "pavanbhat1999/figlet.nvim",
    event = "User FilePost",
    dependencies = {
      "numToStr/Comment.nvim",
    },
    keys = {
      { "<leader>aa", "<cmd>FigCommentPrompt<cr>", { desc = "Create ascii art comment" } },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>fr",
        "<cmd>lua require('spectre').toggle()<cr>",
        desc = "Toggle spectre",
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require "configs.spectre"
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "User FilePost",
    config = function()
      vim.g.VM_maps["Get Operator"] = "<Leader>a"
      vim.g.VM_maps["Reselect Last"] = "<Leader>z"
      vim.g.VM_maps["Visual Cursors"] = "<Leader><Space>"
      vim.g.VM_maps["Undo"] = "u"
      vim.g.VM_maps["Redo"] = "<C-r>"
      vim.g.VM_maps["Visual Subtract"] = "zs"
      vim.g.VM_maps["Visual Reduce"] = "zr"
    end,
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.conform"
    end,
    keys = {

      {
        "<leader>fm",
        function()
          require("conform").format { lsp_fallback = true }
        end,
        { desc = "general format file" },
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    lazy = false,
    config = function(opts)
      require("mason").setup(opts)
    end,
    opts = function()
      local opts = require "configs.mason"

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})
      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.null-ls"
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "User FilePost",
    opts = function()
      return require "configs.trouble"
    end,
    cmd = "Trouble",
    keys = {
      {
        "<leader>tr",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tR",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    dependencies = {
      -- virtual text for the debugger
      { "theHamsta/nvim-dap-virtual-text" },
      -- fancy UI for the debugger
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      --- languages
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
      },
      -- dap cmp source
      { "rcarriga/cmp-dap" },
    },
    config = function()
      require "configs.dap"
    end,
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- If you want insert `(` after select function or method item
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "github/copilot.vim",
    event = "User FilePost",
    config = function()
      vim.g.copilot_no_tab_map = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
      vim.api.nvim_set_keymap("i", "<C-O>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" }, -- for telescope integration
    },
    opts = {
      debug = false,
      window = {
        layout = "horizontal",
        relative = "cursor",
      },
    },
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input "Ask copilot : "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>ccp",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>cch",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      {
        "<leader>cco",
        function()
          require("CopilotChat").open()
        end,
        desc = "CopilotChat - Open chat",
      },
    },
  },
}

return M
