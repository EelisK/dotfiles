-- Detect and set the proper file type for sshconfig files

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/sshconfig", { clear = true })

local pattern = {
  "*/.ssh/config",
  "*/.ssh/config.d/*",
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = pattern,
  callback = function()
    vim.bo.filetype = "sshconfig"
  end,
})
