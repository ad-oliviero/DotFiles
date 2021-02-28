source ~/.vim/vim.plug

set relativenumber
syntax on
filetype plugin indent on
set tabstop=4
"set autoindent
set termguicolors
let ayucolor="dark"
colorscheme ayu
highlight Search ctermfg=0

" searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" backspace over everything
set backspace=indent,eol,start


hi User1 ctermbg=gray  ctermfg=black
hi User2 ctermbg=gray  ctermfg=red cterm=bold

set laststatus=2
set statusline=     "reset statusline
set statusline+=%1* "black on gray
set statusline+=%F      "full filename
" set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
" set statusline+=%{&ff}] "file format
set statusline+=\ %y    "filetype
set statusline+=\ %h    "help file flag
set statusline+=\ %2*   "white on red
set statusline+=%m      "modified flag
set statusline+=%1* "black on gray
set statusline+=\ %r    "read only flag
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ \ %P  "percent through file
