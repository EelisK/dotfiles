local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- user event that loads after UIEnter + only if file buf is there
local userfilepost = augroup("eelisk/events/UserFilePost", { clear = true })
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = userfilepost,
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_id(userfilepost)

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

local termopen = augroup("eelisk/events/TermOpen", { clear = true })
autocmd("TermOpen", {
  group = termopen,
  callback = function(args)
    -- set buffer as unlisted
    vim.api.nvim_set_option_value("buflisted", false, { buf = args.buf })
  end,
})

local chezmoimanagedfile = vim.api.nvim_create_augroup("eelisk/chezmoi/ftdetect", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = chezmoimanagedfile,
  pattern = vim.fn.expand "~" .. "/.local/share/chezmoi/**",
  desc = "Detect and set the proper file type for dotfiles under chezmoi management.",
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf):match ".*/(.*)"
    if not file then
      return
    end
    -- ignore files with leading dot
    if string.match(file, "^%.") then
      return
    end
    local base_name = file:gsub(".tmpl$", "")
    base_name = base_name:gsub("^dot_", ".")
    if base_name then
      local filetype = vim.filetype.match { filename = base_name }
      if filetype then
        vim.api.nvim_set_option_value("filetype", filetype, { buf = args.buf })
      end
    end
  end,
})

-- apply dotenv changes automatically on save
local chezmoisync = augroup("eelisk/chezmoi/sync", { clear = true })
autocmd("BufWritePost", {
  pattern = vim.fn.expand "~" .. "/.local/share/chezmoi/*",
  group = chezmoisync,
  callback = function()
    local cmd = 'chezmoi apply --source-path "' .. vim.fn.expand "%:p" .. '"'
    local handle
    ---@diagnostic disable-next-line: missing-fields, undefined-field
    handle, _ = vim.loop.spawn("sh", {
      args = { "-c", cmd },
      detach = true,
    }, function()
      handle:close()
    end)
  end,
})

-- reload neovim on save
local reloadonsave = augroup("eelisk/actions/reload", { clear = true })
autocmd("BufWritePost", {
  group = reloadonsave,
  pattern = vim.tbl_map(function(path)
    ---@diagnostic disable-next-line: undefined-field
    local realpath = vim.uv.fs_realpath(path)
    if not realpath then
      return path
    end
    return vim.fs.normalize(realpath)
  end, vim.fn.glob(vim.fn.stdpath "config" .. "/lua/**/*.lua", true, true, true)),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

    if module then
      require("plenary.reload").reload_module(module)
    end
  end,
})

local disableautocomment = augroup("eelisk/actions/disableautocomment", { clear = true })
autocmd({ "BufEnter", "CmdLineLeave", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  group = disableautocomment,
  desc = "Disable autocomment on enter",
})

-- Handle jar file URIs
-- eg. "jar:file:///path/to/src.zip!/java.base/java/util/Foo.java"
local jarfile = augroup("eelisk/lsp/jarfile", { clear = true })
autocmd("BufNew", {
  group = jarfile,
  pattern = "jar:file://*",
  callback = function(args)
    vim.bo[args.buf].buftype = "nofile"
    vim.bo[args.buf].swapfile = false
  end,
})
autocmd("BufReadCmd", {
  group = jarfile,
  pattern = "jar:file://*",
  callback = function(args)
    local buf_name = vim.api.nvim_buf_get_name(args.buf)
    local zip_path, inner_path = buf_name:match "jar:file://(.-)!/(.*)"
    if not zip_path or not inner_path then
      return
    end
    local content = vim.fn.systemlist { "unzip", "-p", zip_path, inner_path }
    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to extract " .. inner_path .. " from " .. zip_path, vim.log.levels.ERROR)
      return
    end
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, content)
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].readonly = true
    local filetype = vim.filetype.match { filename = inner_path }
    if filetype then
      vim.bo[args.buf].filetype = filetype
    end
  end,
})

-- Highlight on yank
local yankhighlight = augroup("eelisk/actions/yankhighlight", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.hl.on_yank()
  end,
  group = yankhighlight,
})
