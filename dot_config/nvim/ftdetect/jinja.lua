-- Detect and set the proper file type for jinja template files.

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/jinja", { clear = true })

local pattern = {
  "**/*.j2",
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = pattern,
  callback = function()
    vim.bo.filetype = "jinja"
  end,
})
