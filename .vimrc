" This vimrc is mostly taken from https://github.com/ayesumit/Android-Nvim

call plug#begin("~/.vim/autoload/plug")

Plug 'vim-scripts/chlordane.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
"Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-sleuth'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
"Plug 'mg979/vim-visual-multi'
Plug 'mattn/emmet-vim'
Plug 'honza/vim-snippets'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'
Plug '907th/vim-auto-save'
Plug 'mcchrish/nnn.vim'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" custom commands

syntax enable

" set termguicolors
"colorscheme tokyonight
"set background=dark

"let ayucolor="light"
"let ayucolor="mirage"
let ayucolor="dark"

filetype on
set number
set relativenumber
"set cursorline
set ruler
set mouse=a
set scrolloff=8
set nowrap
set lazyredraw
" Cmd
set showmatch
set noshowmode
set noerrorbells
set cmdheight=1
set wildmenu
"set wildmode=full
set laststatus=2
set completeopt=menuone,longest
set pumheight=5
set shortmess+=c

" Term
set splitbelow splitright

" Search
set incsearch
set nohlsearch
set smartcase
set ignorecase

" Tabs
filetype indent on
set smartindent
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=2

" Folds
set foldenable
set foldmethod=syntax
set foldnestmax=10
set foldlevelstart=99

" Misc
"set formatoptions-=cro
"set autochdir
"set updatetime=300
set nobackup
set nowritebackup
set undodir=~/.vim/.tmp
set undofile

" Remaps
"Basics
let mapleader=","

au! BufWritePost $MYVIMRC source %
nnoremap <silent> <Leader><Leader> :source $MYVIMRC<cr>
nnoremap <silent> <Leader>v :e $MYVIMRC<cr>

"inoremap kj <Esc>
command -nargs=0 W :w !sudo tee %
nnoremap <C-s> :w<CR>
nnoremap <C-Q> :wq!<CR>
nnoremap qq :q!<CR>

nnoremap <Space> za

noremap <silent> <C-Up> :res +2<CR>
noremap <silent> <C-Down> :res -2<CR>
noremap <silent> <C-Left> :vert res +2<CR>
noremap <silent> <C-Right> :vert res -2<CR>

nnoremap <C-Up> :m .-2<CR>==
nnoremap <C-Down> :m .+1<CR>==
vnoremap <C-Up> :m '<-2<CR>gv=gv
vnoremap <C-Down> :m '>+1<CR>gv=gv


nnoremap <Leader>l :ls<CR>
nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>
nnoremap <Leader>= :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>


inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"


" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =

" Plugin Config zone
let g:lightline = {
\   'colorscheme': 'ayu',
\   'active': {
\    'left' :[[ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified' ]],
\    'right':[[ 'percent', 'lineinfo' ] ]
\   },
\ 'mode_map': {
\ 'n' : 'N',
\ 'i' : 'I',
\ 'R' : 'R',
\ 'v' : 'V',
\ 'V' : 'VL',
\ "\<C-v>": 'VB',
\ 'c' : 'C',
\ 's' : 'S',
\ 'S' : 'SL',
\ "\<C-s>": 'SB',
\ 't': 'T'
\ },
\}

" IndentLine
let g:indentLine_char = '|'
let g:indentLine_first_char = ''
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1

let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]
let g:auto_save_silent = 1
let g:auto_save_write_all_buffers = 1

let g:nnn#set_default_mappings = 0
nnoremap <leader>n :NnnPicker %:p:h<CR>
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
let g:nnn#session = 'global'

let g:coc_global_extensions = ['coc-sh','coc-snippets']
