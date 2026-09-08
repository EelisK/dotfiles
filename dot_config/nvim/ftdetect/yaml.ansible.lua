-- Detect and set the proper file type for Ansible YAML files

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/yaml.ansible", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group,
  pattern = {
    "*/playbooks/*.{yml,yaml}",
    "*/roles/*/tasks/*.{yml,yaml}",
    "*/roles/*/handlers/*.{yml,yaml}",
    "*/roles/*/meta/*.{yml,yaml}",
    "*/roles/*/defaults/*.{yml,yaml}",
    "*/roles/*/vars/*.{yml,yaml}",
    "*/group_vars/*.{yml,yaml}",
    "*/host_vars/*.{yml,yaml}",
    "*/tasks/*.{yml,yaml}",
    "*/handlers/*.{yml,yaml}",
    "*/defaults/*.{yml,yaml}",
    "*/vars/*.{yml,yaml}",
    "*/meta/*.{yml,yaml}",
    "*/molecule/*.{yml,yaml}",
    "*/site.{yml,yaml}",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})
