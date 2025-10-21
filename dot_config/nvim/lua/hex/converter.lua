local M = {}

--- Dump the current buffer to a hex representation using xxd
function M:dump()
  vim.bo.bin = true
  vim.b["hex"] = true
  vim.cmd([[%! xxd -g 1 -u "]] .. vim.fn.expand "%:p" .. [["]])
  vim.b.hex_ft = vim.bo.ft
  vim.bo.ft = "xxd"
  vim.bo.mod = false
  vim.bo.readonly = true
end

--- Assemble the current buffer from a hex representation using xxd
function M:assemble()
  vim.bo.readonly = false
  vim.cmd [[%! xxd -r]]
  vim.bo.ft = vim.b.hex_ft
  vim.bo.mod = false
  vim.b["hex"] = false
end

return M
