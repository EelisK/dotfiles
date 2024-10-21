local conform = require "conform"

local options = {
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  lsp_fallback = true,
  formatters = {
    shfmt = {
      prepend_args = { "-i", "4" },
    },
    ruff_import = {
      command = "ruff",
      stdin = false,
      args = { "check", "--select", "I", "--fix", "$FILENAME" },
    },
  },
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier", "yamllint" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
    python = function(bufnr)
      if conform.get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format", "ruff_import" }
      else
        return { "isort", "black" }
      end
    end,
    go = { "goimports", "gofmt" },
    terraform = { "terraform_fmt", "tfsec" },
    jinja = { "prettier" },
    ruby = { "rubocop", "solargraph" },
    rust = { "rustfmt" },
    bash = { "beautysh", "shfmt" },
    sh = { "beautysh", "shfmt" },
    zsh = { "beautysh", "shfmt" },
    sql = { "sqlfluff" },
    ["yaml.ansible"] = { "prettier", "ansible_lint" },
    -- Use the "*" filetype to run formatters on all filetypes.
    ["*"] = { "codespell" },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { lsp_fallback = true, timeout_ms = 1500, async = false }
  end,
}

conform.setup(options)
