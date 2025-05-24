local M = { "williamboman/mason.nvim" }

M.cmd = { "Mason", "MasonInstall", "MasonUpdate" }

M.lazy = false

M.opts = {
  ---@type '"prepend"' | '"append"' | '"skip"'
  PATH = "prepend",
}

return M
