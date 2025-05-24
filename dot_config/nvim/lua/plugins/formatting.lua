local _conform = nil
local function conform()
  if _conform == nil then
    _conform = require "conform"
  end
  return _conform
end

local options = {
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  lsp_fallback = "never",
  formatters = {
    shfmt = {
      prepend_args = { "-i", "4" },
    },
    ruff_import = {
      command = "ruff",
      stdin = false,
      args = { "check", "--select", "I", "--fix", "$FILENAME" },
    },
    rubocop = {
      args = {
        "--autocorrect-all",
        "--format",
        "quiet",
        "--debug",
        "$FILENAME",
      },
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
      if conform().get_formatter_info("ruff_format", bufnr).available then
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
    return { lsp_fallback = false, timeout_ms = 1500, async = false }
  end,
}

return {
  "stevearc/conform.nvim",
  event = "User FilePost",
  opts = options,
  keys = {
    {
      "<leader>fm",
      function()
        conform().format()
      end,
      { desc = "general format file" },
    },
  },
  config = function(_, opts)
    conform().setup(opts)
    vim.api.nvim_create_user_command("ConformFormat", function()
      conform().format { lsp_fallback = false }
    end, { desc = "Format file" })
    vim.api.nvim_create_user_command("ConformDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable auto-format on save" })
    vim.api.nvim_create_user_command("ConformEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Enable auto-format on save" })
  end,
}
