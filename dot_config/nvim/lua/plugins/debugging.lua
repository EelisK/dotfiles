local M = { "mfussenegger/nvim-dap" }

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

M.event = "VeryLazy"

-- stylua: ignore start
---@diagnostic disable: undefined-field
M.keys = {
  { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
  { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
  { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
  { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
  { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
  { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to line (no execute)" },
  { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
  { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
  { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
  { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
  { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
  { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
  { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
  { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
  { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
  { "<leader>dq", function() require("dap").terminate() end,                                            desc = "Terminate" },
  { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
  { "<leader>du", function() require("dapui").toggle({}) end,                                           desc = "Dap UI" },
  { "<leader>de", function() require("dapui").eval() end,                                               desc = "Eval",                   mode = { "n", "v" } },
}
---@diagnostic enable: undefined-field
-- stylua: ignore end

M.dependencies = {
  -- virtual text for the debugger
  { "theHamsta/nvim-dap-virtual-text" },
  -- fancy UI for the debugger
  { "rcarriga/nvim-dap-ui",           dependencies = { "nvim-neotest/nvim-nio" } },
  --- languages
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "DapInstall", "DapUninstall" },
  },
  -- dap cmp source
  { "rcarriga/cmp-dap" },
}

function M.config()
  -- require "configs.dap"
  local dap = require "dap"
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  -- https://microsoft.github.io/vscode-codicons/dist/codicon.html
  local dap_icons = require("icons").dap

  for name, sign in pairs(dap_icons) do
    sign = type(sign) == "table" and sign or { sign }
    vim.fn.sign_define(
      "Dap" .. name,
      ---@diagnostic disable-next-line: assign-type-mismatch
      { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    )
  end

  -------------------
  ---- DAP UI -------
  -------------------
  local dapui_opts = {}
  local dapui = require "dapui"
  dapui.setup(dapui_opts)

  -- Open automatically when a new debug session is created
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open {}
  end
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close {}
  end
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close {}
  end

  -------------------
  -- DAP MASON ------
  -------------------
  local dap_mason_opts = {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,
    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},
    ensure_installed = { "python", "bash", "node2", "delve" },
  }
  require("mason-nvim-dap").setup(dap_mason_opts)

  -------------------
  -- DAP CMP SOURCE -
  -------------------
  local cmp = require "cmp"
  cmp.setup {
    enabled = function()
      if vim.api.nvim_get_option_value("buftype", {
            buf = 0,
          }) == "prompt" then
        return true
      end
      return require("cmp_dap").is_dap_buffer()
    end,
  }

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })

  -----------------------
  -- DAP CONFIGURATIONS -
  -----------------------
  local javascript_languages = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  }
  for _, lang in ipairs(javascript_languages) do
    dap.configurations[lang] = {
      {
        type = "node2",
        name = "Launch",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        type = "node2",
        name = "Attach",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
    }
  end

  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath "data" .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
  }

  dap.adapters.delve = function(callback, config)
    if config.mode == "remote" and config.request == "attach" then
      callback {
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or "38697",
      }
    else
      callback {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap", "--check-go-version=false" },
          detached = vim.fn.has "win32" == 0,
        },
      }
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function(event)
      vim.bo[event.buf]["buflisted"] = false
      require("dap.ext.autocompl").attach()
    end,
  })

  ----------------------
  -- DAP VIRTUAL TEXT --
  ----------------------

  require("nvim-dap-virtual-text").setup {
    enabled = true,                     -- enable this plugin (the default)
    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,            -- show stop reason when stopped for exceptions
    commented = false,                  -- prefix virtual text with comment string
    only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
    all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    display_callback = function(variable, _, _, _, options)
      -- by default, strip out new line characters
      if options.virt_text_pos == "inline" then
        return " = " .. variable.value:gsub("%s+", " ")
      else
        return variable.name .. " = " .. variable.value:gsub("%s+", " ")
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",

    -- experimental features:
    all_frames = false,      -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,      -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
  }
end

return M
