set autoindent " self explanatory
set clipboard=unnamedplus " use system clipboard (works only in gui mode)
set copyindent " copy the previous indentation
set cursorline " line under cursor
set fileencoding=utf-8
set guicursor=n-c-sm:hor20,i-ci-ve:ver25,r-v-cr-o:block " set cursor shape
set hlsearch " highlight search
set ignorecase
set lazyredraw
set mouse=a " mouse click
set number " line numbers
set noswapfile
set nowrap
set nowritebackup
set preserveindent
set pumheight=10
set shiftwidth=2 " auto indent size
set showtabline=2 " always show tab line
set smartindent " smart indentation
set spelllang=it,en_us
set tabstop=2 " tab size
set termguicolors " true color
set tags+=$HOME/Dev/tags
set undofile
set wildmode=longest,list " completions
syntax on " syntax highlighting
setlocal spell
filetype plugin indent on " file type based indent style

" highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Plugins
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install'}
Plug 'sbdchd/neoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'github/copilot.vim'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
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

" some auto things
autocmd InsertEnter * norm zz
nnoremap n nzzzv
nnoremap N Nzzzv
autocmd VimLeave * set guicursor=a:ver25 " reset cursor after leaving

nnoremap <F2> :NERDTreeToggle<CR>

" move line or visually selected block - alt+j/k
noremap <A-j> <Esc>:m .+1<CR>==
noremap <A-k> <Esc>:m .-2<CR>==
noremap <A-down> <Esc>:m .+1<CR>==
noremap <A-up> <Esc>:m .-2<CR>==

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

" coc settings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nmap <leader>do <Plug>(coc-codeaction)
nmap <leader>rn <Plug>(coc-rename)
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

command -nargs=0 W :w !sudo tee >/dev/null %
