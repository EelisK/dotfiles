-- Detect and set the proper file type for Ansible YAML files

local group = vim.api.nvim_create_augroup("eelisk/ftdetect/yaml.ansible", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group,
  pattern = {
    "*/playbooks/*.yml",
    "*/playbooks/*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*/roles/*/handlers/*.yml",
    "*/roles/*/handlers/*.yaml",
    "*/roles/*/meta/*.yml",
    "*/roles/*/meta/*.yaml",
    "*/roles/*/defaults/*.yml",
    "*/roles/*/defaults/*.yaml",
    "*/roles/*/vars/*.yml",
    "*/roles/*/vars/*.yaml",
    "*/group_vars/*.yml",
    "*/group_vars/*.yaml",
    "*/host_vars/*.yml",
    "*/host_vars/*.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})
