return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
    "mrbjarksen/neo-tree-diagnostics.nvim",
  },
  keys = {
    {
      "<C-t>",
      function()
        require("neo-tree.command").execute { toggle = true }
      end,
      desc = "Toggle NeoTree",
    },
  },
  config = function()
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
          local path = vim.fn.getcwd()
          local stats = vim.uv.fs_stat(path)
          if stats and stats.type == "directory" then
            require "neo-tree"
          end
        end
      end,
    })

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

    require("window-picker").setup {
      -- type of hints you want to get
      -- following types are supported
      -- 'statusline-winbar' | 'floating-big-letter'
      -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
      -- 'floating-big-letter' draw big letter on a floating window
      -- used
      hint = "floating-big-letter",

      -- when you go to window selection mode, status bar will show one of
      -- following letters on them so you can use that letter to select the window
      selection_chars = "FJDKSLA;CMRUEIWOQP",

      -- This section contains picker specific configurations
      picker_config = {
        statusline_winbar_picker = {
          -- You can change the display string in status bar.
          -- It supports '%' printf style. Such as `return char .. ': %f'` to display
          -- buffer file path. See :h 'stl' for details.
          selection_display = function(char, _)
            return "%=" .. char .. "%="
          end,

          -- whether you want to use winbar instead of the statusline
          -- "always" means to always use winbar,
          -- "never" means to never use winbar
          -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
          use_winbar = "never", -- "always" | "never" | "smart"
        },

        floating_big_letter = {
          -- window picker plugin provides bunch of big letter fonts
          -- fonts will be lazy loaded as they are being requested
          -- additionally, user can pass in a table of fonts in to font
          -- property to use instead

          font = "ansi-shadow", -- ansi-shadow |
        },
      },

      -- whether to show 'Pick window:' prompt
      show_prompt = true,

      -- prompt message to show to get the user input
      prompt_message = "Pick window: ",

      -- if you want to manually filter out the windows, pass in a function that
      -- takes two parameters. You should return window ids that should be
      -- included in the selection
      -- EX:-
      -- function(window_ids, filters)
      --    -- folder the window_ids
      --    -- return only the ones you want to include
      --    return {1000, 1001}
      -- end
      filter_func = nil,

      -- following filters are only applied when you are using the default filter
      -- defined by this plugin. If you pass in a function to "filter_func"
      -- property, you are on your own
      filter_rules = {
        -- when there is only one window available to pick from, use that window
        -- without prompting the user to select
        autoselect_one = true,

        -- whether you want to include the window you are currently on to window
        -- selection or not
        include_current_win = false,

        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { "NvimTree", "neo-tree", "notify" },

          -- if the file type is one of following, the window will be ignored
          buftype = { "terminal" },
        },

        -- filter using window options
        wo = {},

        -- if the file path contains one of following names, the window
        -- will be ignored
        file_path_contains = {},

        -- if the file name contains one of following names, the window will be
        -- ignored
        file_name_contains = {},
      },

      -- You can pass in the highlight name or a table of content to set as
      -- highlight
      highlights = {
        statusline = {
          focused = {
            fg = "#ededed",
            bg = "#e35e4f",
            bold = true,
          },
          unfocused = {
            fg = "#ededed",
            bg = "#44cc41",
            bold = true,
          },
        },
        winbar = {
          focused = {
            fg = "#ededed",
            bg = "#e35e4f",
            bold = true,
          },
          unfocused = {
            fg = "#ededed",
            bg = "#44cc41",
            bold = true,
          },
        },
      },
    }

    -- local sources =

    vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
    require("neo-tree").setup {
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

                    vim.loop.fs_rename(source_file, target_file, function(err)
                      if err then
                        print "Could not move the file"
                        return
                      else
                        print("Moved " .. node.name .. " successfully")
                        tree:render()
                      end
                    end)
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
  end,
}
