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
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>',
               {noremap = true, silent = true})
vim.keymap.set('v', 's', '<Plug>VSurround', {noremap = false})
