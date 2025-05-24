---
--- https://github.com/ansible/vscode-ansible
---
--- Language server for the ansible configuration management tool.
---

return {
  cmd = { "ansible-language-server", "--stdio" },
  root_markers = {
    "ansible.cfg",
    ".ansible-lint",
  },
  filetypes = { "yaml.ansible" },
  single_file_support = true,
  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      ansible = {
        path = "ansible",
      },
      executionEnvironment = {
        enabled = false,
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint",
        },
      },
    },
  },
}
