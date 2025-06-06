---@type vim.lsp.Config
return {
  cmd = { "metals" },
  filetypes = { "scala" },
  root_markers = { "build.sbt", "build.sc", "build.gradle", "pom.xml" },
  init_options = {
    statusBarProvider = "show-message",
    isHttpEnabled = true,
    compilerOptions = {
      snippetAutoIndent = false,
    },
  },
  capabilities = {
    workspace = {
      configuration = false,
    },
  },
  settings = {
    ["metals"] = {
      filetypes = { "sbt", "scala", "java" },
    },
  },
}
