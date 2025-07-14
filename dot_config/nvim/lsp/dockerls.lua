---
--- https://github.com/rcjsuen/dockerfile-language-server-nodejs
---
--- A language server for Dockerfiles.

---@type vim.lsp.Config
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile" },
}
