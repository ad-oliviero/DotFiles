set autoindent copyindent preserveindent smartindent		" autoindend copying the previous indentation
set fileencoding=utf-8																	" default file encoding
set guicursor=n-c-sm:hor20,i-ci-ve:ver25,r-v-cr-o:block	" set cursor shape
set hlsearch ignorecase																	" highlight search
set mouse=a clipboard=unnamedplus												" mouse click and system clipboard
set number cursorline lazyredraw												" line numbers, line under cursor, fast rendering
set nowrap																							" disable line wrapping
set noswapfile nowritebackup undofile										" history settings
set pumheight=10																				" max items count in pop up menu
set shiftwidth=2 tabstop=2															" auto indent and tab size
set showtabline=2																				" always show tab name
set spelllang=it,en_us spell														" spelling
set termguicolors																				" true color
set tags+=$HOME/Dev/tags																" auto complete from my own code
set cot=menu,menuone,noselect wim=longest,list					" completions
set list lcs=tab:——,space:·,extends:◣,precedes:◢				" show invisible characters
syntax on																								" syntax highlighting
filetype plugin indent on																" file type based indent style

" highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Plugins
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'neovim/nvim-lspconfig'
Plug 'lukas-reineke/lsp-format.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
call plug#end()

colorscheme gruvbox

if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
augroup vimtex_config
	autocmd User VimtexEventInitPost VimtexCompile
augroup END

" latex and markdown filetypes
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.md set filetype=markdown

" some auto things
autocmd InsertEnter * norm zz
nnoremap n nzzzv
nnoremap N Nzzzv
autocmd VimLeave * set guicursor=a:ver25 " reset cursor after leaving

nnoremap <F2> :NERDTreeToggle<CR>

inoremap <A-i> <ESC>:Format<CR>
nnoremap <A-i> <ESC>:Format<CR>

" move line or visually selected block - alt+j/k
noremap <A-j> :m .+1<CR>==
noremap <A-k> :m .-2<CR>==
noremap <A-down> :m .+1<CR>==
noremap <A-up> :m .-2<CR>==

" jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal! g'\"" | endif
endif

" nerdcommenter settings
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_c = 1
let g:NERDAltDelims_cpp = 1

inoremap <A-c> <ESC>:call nerdcommenter#Comment('n', 'Toggle')<CR>
nnoremap <A-c> :call nerdcommenter#Comment('n', 'Toggle')<CR>
vnoremap <A-c> :call nerdcommenter#Comment('n', 'Toggle')<CR>
inoremap <C-A-c> <ESC>:call nerdcommenter#Comment('n', 'Invert')<CR>
nnoremap <C-A-c> :call nerdcommenter#Comment('n', 'Invert')<CR>
vnoremap <C-A-c> :call nerdcommenter#Comment('n', 'Invert')<CR>
inoremap <S-A-c> <ESC>:call nerdcommenter#Comment('n', 'Invert')<CR>
nnoremap <S-A-c> :call nerdcommenter#Comment('n', 'Comment')<CR>
vnoremap <S-A-c> :call nerdcommenter#Comment('n', 'Comment')<CR>

lua require('config')
