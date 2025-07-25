local o = vim.opt

-- stylua: ignore start
-- :help options
o.backup = false                          -- creates a backup file
o.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
o.cmdheight = 2                           -- more space in the neovim command line for displaying messages
o.completeopt = { "menuone", "noselect" } -- mostly just for cmp
o.conceallevel = 0                        -- so that `` is visible in markdown files
o.fileencoding = "utf-8"                  -- the encoding written to a file
o.hlsearch = true                         -- highlight all matches on previous search pattern
o.ignorecase = true                       -- ignore case in search patterns
o.mouse = ""                              -- allow the mouse to be used in neovim
o.mousescroll = "ver:0,hor:0"             -- disable mouse scrolling
o.pumheight = 10                          -- pop up menu height
o.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 2                         -- always show tabs
o.smartcase = true                        -- smart case
o.smartindent = true                      -- make indenting smarter again
o.splitbelow = true                       -- force all horizontal splits to go below current window
o.splitright = true                       -- force all vertical splits to go to the right of current window
o.swapfile = false                        -- creates a swapfile
o.termguicolors = true                    -- set term gui colors (most terminals support this)
o.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
o.undofile = true                         -- enable persistent undo
o.updatetime = 300                        -- faster completion (4000ms default)
o.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
o.expandtab = true                        -- convert tabs to spaces
o.shiftwidth = 2                          -- the number of spaces inserted for each indentation
o.tabstop = 2                             -- insert 2 spaces for a tab
o.cursorline = false                      -- highlight the current line
o.number = true                           -- set numbered lines
o.relativenumber = true                   -- set relative numbered lines
o.numberwidth = 4                         -- set number column width to 2 {default 4}
o.laststatus = 3                          -- always show the status line
o.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
o.wrap = true                             -- display lines as one long line
o.fillchars:append { eob = " " }          -- hide ~ at end of buffer
o.fixendofline = true                     -- fix end of line
o.winborder = "rounded"                   -- border style
o.foldcolumn = '1'                        -- set fold column width to 1 {default 0}
o.foldlevel = 99                          -- close few folds by default
o.foldlevelstart = 99                     -- start new buffer with all folds open
o.foldenable = true                       -- enable folding
o.foldmethod = "expr"                     -- set fold method to expression (default to treesitter folding)
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.fillchars:append { fold = " " }
o.fillchars:append { foldsep = " " }
o.fillchars:append { foldclose = "" }
o.fillchars:append { foldopen = "" }
o.scrolloff = 8
o.sidescrolloff = 8
-- vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
-- stylua: ignore end

vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

-- disable startup message
o.shortmess:append "I"

-- whichwrap allows for birectional navigation between lines
vim.cmd "set whichwrap+=<,>,[,],h,l"
