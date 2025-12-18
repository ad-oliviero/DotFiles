local o = vim.opt
local g = vim.g
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

o.number = true          -- show line numbers
o.shortmess:append('sI') -- disable nvim default initial page
o.signcolumn = 'yes'     -- default space for small error and warning messages
o.winborder = 'single'   -- set border for all windows
-- o.textwidth = 80
-- o.mousescroll = "ver:10,hor:2"
o.mouse = "a"

o.cindent = true            -- auto indent, c-style
o.shiftwidth = 2            -- tab size stuff
o.smarttab = true           -- tab size stuff
o.softtabstop = 2           -- tab size stuff

o.clipboard = 'unnamedplus' -- copy to system clipboard
o.spell = true
o.spl = { 'it', 'en_us' }   -- set spelling languages
o.undofile = true
-- o.whichwrap:append('<>[]hl') -- go to next line with arrows or h or l
o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

g.mapleader = ' '

vim.pack.add({
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/Shatur/neovim-ayu',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/echasnovski/mini.pick',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/karb94/neoscroll.nvim',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/lervag/vimtex',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/nyoom-engineering/oxocarbon.nvim',
  'https://github.com/rmagatti/auto-session',
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/wakatime/vim-wakatime',
  'https://github.com/windwp/nvim-autopairs',
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1.*') },
})
require 'bufferline'.setup()
require 'mini.pick'.setup()
-- require 'gruvbox'.setup({ transparent_mode = true })
require 'ayu'.colorscheme()
-- require 'kanagawa'.setup({ compile = true, transparent = true })
require 'smear_cursor'.setup()
require 'neoscroll'.setup({
  performance_mode = true,
})
require 'nvim-surround'.setup({
  keymaps = {
    visual = 's',
    visual_line = 'S',
    delete = 'sd',
    change = 'sr',
  },
  aliases = {
    ['i'] = ']', -- Index
    ['r'] = ')', -- Round
    ['b'] = '}', -- Brackets
  },
  move_cursor = false,
})
g.vimtex_view_method = "sioyek"
require 'nvim-autopairs'.setup()
require 'mason'.setup()
local servers = {
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'texlab',
  'denols',
  'qmlls',
}
-- some lang servers are not available for arm, they must be installed manually
if not (vim.fn.systemlist('uname -m')[1] == 'aarch64' or vim.fn.systemlist('uname -m')[1] == 'arm64') then
  vim.list_extend(servers, {
    'clangd',
    'hyprls'
  })
else
  vim.lsp.enable({
    'clangd',
    'hyprls'
  })
end
require 'mason-lspconfig'.setup({ ensure_installed = servers })
require 'render-markdown'.setup()
require 'Comment'.setup({
  toggler = {
    line = '<leader>\\',
    block = '<leader>|',
  },
  opleader = {
    line = '<leader>\\',
    block = '<leader>|',
  },
  mappings = { extra = false }
})
require 'auto-session'.setup()
require 'conform'.setup({
  formatters_by_ft = {
    python = { 'isort', 'black' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    nix = { 'alejandra' },
  },
  format_on_save = {
    timeout_ms = 300,
    lsp_format = "fallback",
  },
})
require 'blink.cmp'.setup({ keymap = { preset = 'enter' } })

-- mason-lspconfig does not let me to set ensure_installed formatters
local registry = require('mason-registry')
for _, pkg_name in ipairs { 'isort', 'black', 'prettier' } do
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if ok then
    if not pkg:is_installed() then
      pkg:install()
    end
  end
end

-- vim.cmd.colorscheme 'oxocarbon'
vim.cmd.set 'completeopt+=noselect,noinsert' -- don't auto { select the first option, insert whatever is selected }

map('n', '<leader>so', ':update<CR> :source<CR>', { desc = 'Reload the config' })
map('n', '<C-,>', ':e $MYVIMRC<CR>', { desc = 'Open config to edit' })
map('n', '<leader>h', ':Pick help<CR>', { desc = 'Help Pick menu' })
map('n', '<leader>wk', ':WhichKey<CR>', { desc = 'Show WhichKey' })

-- opened file navigation
map('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<leader>x', ':bdelete<CR>', { desc = 'Delete Buffer' })
map('n', '<leader>b', ':Pick buffers<CR>', { desc = 'Buffers Pick menu' })
map('n', '<leader>ff', ':Pick files<CR>', { desc = 'Files Pick menu' })

-- move lines like in vscode
map('n', '<A-up>', ':m .-2<CR>==', { desc = 'Move line up' })
map('n', '<A-down>', ':m .+1<CR>==', { desc = 'Move line down' })
map('v', '<A-down>', ':m \'>+1<CR>gv=gv', { desc = 'Move line down' })
map('v', '<A-up>', ':m \'<-2<CR>gv=gv', { desc = 'Move line up' })

map('n', '<C-S>', ':w<CR>', { desc = 'Write to File' }) -- yes, i don't care

-- dev
map('n', '<leader>lf', require "conform".format, { desc = 'Format file' })
map('n', '<leader>r', function()
  vim.cmd('w')
  vim.cmd('make')
end, { desc = 'Call make' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.o.makeprg = 'python3 %';
  end,
})
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Invoke LSP code action' })

if vim.fn.has('autocmd') then -- open file in the last position
  autocmd('BufReadPost', {
    callback = function()
      vim.cmd [[normal! g`']]
      vim.schedule(function() -- center the line as soon as it is possible
        vim.cmd([[normal! zz]])
      end)
    end,
  })
end

vim.filetype.add({ -- *.conf files in the hypr directory are of hyprlang type
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
})
