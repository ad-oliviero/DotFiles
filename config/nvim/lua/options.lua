-- Indentation
vim.opt.autoindent = true -- maintain indent of previous line
vim.opt.copyindent = true -- copy the previous line's indent when autoindenting
vim.opt.preserveindent = true -- preserve the indent of the current line
vim.opt.smartindent = true -- insert indents automatically
vim.opt.shiftwidth = 2 -- number of spaces for each indentation level

-- System Integration
vim.opt.mouse = 'a' -- enable mouse support in all modes
vim.opt.clipboard = 'unnamedplus' -- use the system clipboard
vim.opt.whichwrap:append '<,>,[,]'
vim.g.mapleader = ' '

--- History
vim.opt.swapfile = false -- disable swap file
vim.opt.writebackup = false -- do not write backup files
vim.opt.undofile = true -- enable persistent undo
vim.opt.fileencoding = 'utf-8' -- set file encoding to utf-8

--- Visuals
vim.cmd.color [[gruvbox]] -- set the color scheme
vim.opt.laststatus = 3 -- always show the statusline
vim.opt.fillchars = {eob = ' '} -- replace ~ at the end of the buffer with a space
vim.opt.showmode = false -- do not show the current mode
vim.opt.number = true -- show line numbers
vim.opt.numberwidth = 2 -- set width of the line number column
vim.opt.ruler = false -- do not show the cursor position in the statusline
vim.opt.shortmess:append 'sI' -- disable nvim initial page help
vim.opt.signcolumn = 'yes' -- always show the sign column
vim.opt.splitbelow = true -- open new split panes below the current pane
vim.opt.splitright = true -- open new split panes to the right of the current pane
vim.opt.cursorline = true -- highlight the current line
vim.opt.lazyredraw = true -- do not redraw the screen while running macros
vim.opt.hlsearch = true -- highlight search results
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- override ignorecase if search pattern contains uppercase letters
vim.opt.pumheight = 10 -- limit the number of items displayed in the popup menu
vim.opt.showtabline = 2 -- always show the tabline
vim.opt.tabstop = 2 -- number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2 -- number of spaces that a <Tab> key in insert mode inserts or removes
vim.opt.wrap = true -- wrap lines that exceed the width of the window
vim.opt.termguicolors = true -- enable true colors in the terminal
vim.opt.syntax = 'on' -- enable syntax highlighting
vim.opt.lcs = { -- set the characters used to render whitespace
    tab = '——',
    space = '·',
    extends = '◣',
    precedes = '◢'
}
vim.opt.list = true -- show whitespace characters

--- Completion
vim.opt.spl = {'it', 'en_us'} -- set the spell languages
vim.opt.spell = true -- enable spelling correction
vim.opt.cot = 'menuone,noselect' -- enable preview window
vim.opt.wildmenu = true -- enable wildmenu
vim.opt.wim = 'longest,list' -- set wildmenu options (longest common substring and list of completions)
