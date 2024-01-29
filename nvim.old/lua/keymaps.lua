vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set({'n', 'i'}, '<C-d>', '<ESC>viw')
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('n', '<A-down>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-up>', ':m .-2<CR>==')
vim.keymap.set('i', '<C-s>', '<ESC>:wa<CR>a')
vim.keymap.set('n', '<C-s>', ':wa<CR>')
vim.keymap.set('n', '<TAB>', ':bnext<CR>', {noremap = true, silent = true})
vim.keymap
    .set('n', '<S-TAB>', ':bprevious<CR>', {noremap = true, silent = true})
vim.keymap.set({'n', 'i', 'v'}, '<C-q>', '<ESC>:bdelete<CR>',
               {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<A-c>', ':CommentToggle<CR>',
               {noremap = true, silent = true})
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>',
               {noremap = true, silent = true})
vim.keymap.set('v', 's', '<Plug>VSurround', {noremap = false})
vim.keymap.set('n', '<leader>r',
               [[:lua _G.reloading = true<CR>:source $MYVIMRC<CR>:echo 'Vim configuration reloaded.'<CR>]],
               {noremap = true})
vim.keymap.set('n', '<leader>s', [[:LoadSession<CR>]], {noremap = true})
vim.keymap.set('n', '<leader>f', [[:Neoformat<CR>]], {noremap = true})
vim.keymap.set('i', '<C-space>',
               function() return vim.fn['codeium#Accept']() end, {expr = true})
vim.keymap.set('i', '<C-x>',
               function() return vim.fn['codeium#Clear']() end, {expr = true})

