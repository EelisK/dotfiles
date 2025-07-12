-- Detect and set the proper file type for Go template (gotmpl) files.

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/gotmpl", { clear = true })

local pattern = {
  "**/*.tmpl",
  "*/.chezmoitemplates/**",
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = pattern,
  callback = function()
    vim.bo.filetype = "gotmpl"
  end,
})
