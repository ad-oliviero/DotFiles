set nocompatible " disable vi compatibility
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
set clipboard+=unnamedplus " use system clipboard (works only in gui mode)
set cursorline " line under cursor
set ttyfast " fast scrolling
set guicursor= "\<Esc>[5 q
syntax on " syntax highlighting

" highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Plugins
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install'}
Plug 'sbdchd/neoformat'
" Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
call plug#end()

set background=dark
colorscheme gruvbox

" some auto things
autocmd InsertEnter * norm zz
nnoremap n nzzzv
nnoremap N Nzzzv
autocmd VimLeave * call system('printf "\e[5 q" > $TTY')
autocmd VimEnter * call system('printf "\e[3 q" > $TTY')
let &t_SI .= "\<Esc>[5 q"
let &t_EI .= "\<Esc>[3 q"

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

" nerdcommenter settings
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_c = 1
let g:NERDAltDelims_cpp = 1
noremap <A-c> <ESC>:call nerdcommenter#Comment('n', 'Toggle')<CR>

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
" cmap W w !sudo tee > /dev/null %

" latex and markdown filetypes
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.md set filetype=markdown

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
let g:neoformat_rs_enabled = {
			\ 'exe': 'rustfmt',
			\ 'args': [''],
			\ 'replace': 0,
			\ 'stdin': 1,
			\ 'env': [''],
			\ 'valid_exit_codes': [0],
			\ 'no_append': 1,
			\ }
let g:neoformat_latex_enabled = {
			\ 'exe': 'latex-indent',
			\ 'args': [''],
			\ 'replace': 1,
			\ 'stdin': 1,
			\ 'env': [''],
			\ 'valid_exit_codes': [0],
			\ 'no_append': 1,
			\ }
command -nargs=0 W :w !sudo tee >/dev/null %

