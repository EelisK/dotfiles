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

-- Open automatically when a new debug session is created
dap.listeners.after.event_initialized["dapui_config"] = function()
  require("dapui").open()
end

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(event)
    vim.bo[event.buf]["buflisted"] = false
    require("dap.ext.autocompl").attach()
  end,
})
