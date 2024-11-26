local dap = require "dap"
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
-- https://microsoft.github.io/vscode-codicons/dist/codicon.html
local dap_icons = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

for name, sign in pairs(dap_icons) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
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
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open {}
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close {}
end
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
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
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
        args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
        detached = vim.fn.has "win32" == 0,
      },
    }
  end
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    cwd = vim.fn.getcwd(),
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(event)
    vim.bo[event.buf]["buflisted"] = false
    require("dap.ext.autocompl").attach()
  end,
})
