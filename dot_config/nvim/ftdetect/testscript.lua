-- Detect and set the proper file type for testscript files

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/testscript", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = "*/testdata/*.txt",
  callback = function()
    vim.bo.filetype = "testscript"
  end,
})
