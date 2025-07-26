-- Detect and set the proper file type for Dockerfiles.

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/dockerfile", { clear = true })

local pattern = {
  "Dockerfile",
  "Dockerfile.*",
  "Containerfile",
  "*.Containerfile",
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = pattern,
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})
