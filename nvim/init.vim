set nocompatible " disable vi compatibility
" configuration inspired by https://medium.com/geekculture/neovim-configuration-for-beginners-b2116dbbde84
set mouse=a " mouse click
set hlsearch " highlight search
set tabstop=2 " tab size
set softtabstop=2 " space as tab size
" set expandtab " use spaces instead of tabs
set shiftwidth=2 " auto indent size
set autoindent " self explanatory
set number " line numbers
set wildmode=longest,list " completions
filetype plugin indent on " file type based indent style
set clipboard=unnamedplus " use system clipboard (works only in gui mode)
set cursorline " line under cursor
set ttyfast " fast scrolling
set guicursor= "\<Esc>[5 q
set rtp+=~/.vim/bundle/Vundle.vim
syntax on " syntax highlighting

" highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Plugins
call vundle#begin("~/.vim/plugged")
Plugin 'morhetz/gruvbox'
Plugin 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install'}
Plugin 'sbdchd/neoformat'
Plugin 'jiangmiao/auto-pairs'
call vundle#end()

colorscheme gruvbox

" move line or visually selected block - alt+j/k
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi

vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

" jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal! g'\"" | endif
endif
" indent file
function Indent()
	let lnn = line(".")
	normal gg=G
	exe lnn
	:Neoformat
endfunction
inoremap <A-i> <ESC>:call Indent()<CR>
nnoremap <A-i> <ESC>:call Indent()<CR>

" custom commands
command -nargs=0 W :w !sudo tee %
command -nargs=0 WQ :w !sudo tee % <ESC> :q

" neoformat config
let g:neoformat_python_black = {
			\ 'exe': 'black',
			\ 'args': [''],
			\ 'replace': 0,
			\ 'stdin': 1,
			\ 'env': [''],
			\ 'valid_exit_codes': [0],
			\ 'no_append': 1,
			\ }
let g:neoformat_c_enabled = {
			\ 'exe': 'clang-format',
			\ 'args': [''],
			\ 'replace': 1,
			\ 'stdin': 1,
			\ 'env': [''],
			\ 'valid_exit_codes': [0],
			\ 'no_append': 1,
			\ }
let g:neoformat_cpp_enabled = neoformat_c_enabled
let g:neoformat_latex_enabled = {
			\ 'exe': 'latex-indent',
			\ 'args': [''],
			\ 'replace': 1,
			\ 'stdin': 1,
			\ 'env': [''],
			\ 'valid_exit_codes': [0],
			\ 'no_append': 1,
			\ }

