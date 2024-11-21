-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
-- because `cwd` is not set up properly.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
  desc = "Start Neo-tree with directory",
  once = true,
  callback = function()
    if package.loaded["neo-tree"] then
      return
    else
      local stats = vim.uv.fs_stat(vim.fn.argv(0))
      if stats and stats.type == "directory" then
        require "neo-tree"
      end
    end
  end,
})

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

local scan = require "plenary.scandir"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local tactions = require "telescope.actions"
local taction_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local manager = require "neo-tree.sources.manager"
local cc = require "neo-tree.sources.common.commands"
local fs = require "neo-tree.sources.filesystem"
local utils = require "neo-tree.utils"

local function is_dir(name)
  local stats = vim.loop.fs_stat(name)
  return stats and stats.type == "directory"
end

-- local sources =

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
return {
  close_if_last_window = true,
  sources = {
    "filesystem",
    -- "git_status",
    -- "buffers",
    -- "document_symbols",
  },
  enable_git_status = true,
  git_status_async = true,
  enable_diagnostics = false,
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil, -- use a custom function for sorting files and directories in the tree
  -- sort_function = function (a,b)
  --       if a.type == b.type then
  --           return a.path > b.path
  --       else
  --           return a.type > b.type
  --       end
  --   end , -- this sorts files and directories descendantly
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = "*",
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted = "", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",

        conflict = "",
      },
    },
    -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
    file_size = {
      enabled = true,
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },

  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
  window = {
    mappings = {
      ["<CR>"] = function(state)
        cc.open_with_window_picker(state, utils.wrap(fs.toggle_directory, state))
      end,
      -- ["<Tab>"] = function(state)
      --   local cmd = require "neo-tree.command"
      --   local index = {}
      --   local sources = state.sources
      --   for k, v in pairs(sources) do
      --     index[v] = k
      --   end
      --   local next_source_index = (index[state.current_position] + 1) % #sources
      --   local next_source = sources[next_source_index]
      --   cmd.execute { action = "focus", source = next_source }
      -- end,
      ["S"] = "split_with_window_picker",
      ["s"] = "vsplit_with_window_picker",
      ["."] = "set_root",
      ["<bs>"] = "navigate_up",
      ["m"] = function(state)
        local node = state.tree:get_node()
        local tree = state.tree
        local cwd = manager.get_cwd(state)
        local dirs = scan.scan_dir(cwd, { only_dirs = true })
        local relative_dirs = {}
        for _, dir in ipairs(dirs) do
          local relative_dir = dir:gsub(cwd, "")
          table.insert(relative_dirs, relative_dir)
        end

        local opts = require("telescope.themes").get_dropdown {}
        pickers
          .new(opts, {
            prompt_title = "Target directory",
            finder = finders.new_table {
              results = relative_dirs,
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr)
              tactions.select_default:replace(function()
                tactions.close(prompt_bufnr)
                local selection = taction_state.get_selected_entry()

                local source_file = node.path
                local target_dir = cwd .. selection[1]
                target_dir = target_dir .. "/"
                target_dir = target_dir:gsub("//", "/")
                local target_file = target_dir .. node.name

                if not is_dir(target_dir) then
                  vim.notify "Target is not a directory"
                  return
                end

                vim.loop.fs_rename(
                  source_file,
                  target_file,
                  vim.schedule(function(err)
                    if err then
                      print "Could not move the file"
                      return
                    else
                      print("Moved " .. node.name .. " successfully")
                      tree:render()
                    end
                  end)
                )
              end)
              return true
            end,
          })
          :find()
      end,
      ["P"] = { "toggle_preview", config = { use_float = true } },
      ["<esc>"] = "revert_preview",
    },
  },
  filesystem = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      -- the current file is changed while the tree is open.
    },
    hijack_netrw_behavior = "open_current",
    group_empty_dirs = false,
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
        --"thumbs.db"
        --".git",
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
  },
  event_handlers = {
    {
      event = "neo_tree_window_after_open",
      handler = function(args)
        if args.position == "left" or args.position == "right" then
          vim.cmd "wincmd ="
        end
      end,
    },
    {
      event = "neo_tree_window_after_close",
      handler = function(args)
        if args.position == "left" or args.position == "right" then
          vim.cmd "wincmd ="
        end
      end,
    },
  },
}
