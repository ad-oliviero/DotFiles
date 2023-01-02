" --- NeoVim Settings ---
set ai ci pi si sw=2															" autoindend copying the previous indentation
set gcr=n-c-sm:hor20,i-ci-ve:ver25,r-v-cr-o:block	" set cursor shape
set mouse=a clipboard=unnamedplus									" mouse click and system clipboard
set nu cul lz hls ic															" line numbers, line under cursor, fast rendering, search settings
set noswf nowb udf fenc=utf-8											" history settings
set ph=10 stal=2 ts=2 nowrap tgc									" max items count in pop up menu, always show tab name, other visualization settings
set spl=it,en_us spell														" spelling
set tags+=$HOME/Dev/tags													" auto complete from my own code
set cot=menu,menuone,noselect wim=longest,list		" completions
set list lcs=tab:——,space:·,extends:◣,precedes:◢	" show invisible characters
syntax on																					" syntax highlighting
filetype plugin indent on													" file type based indent style

" --- Plugins ---
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

lua require('config')
colo gruvbox

" latex/vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
aug vimtex_config
	au User VimtexEventInitPost VimtexCompile
aug END
au BufRead,BufNewFile *.tex set filetype=tex
au BufRead,BufNewFile *.md set filetype=markdown

" nerdcommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_c = 1
let g:NERDAltDelims_cpp = 1

" --- Automation ---
au InsertEnter * norm zz
au VimLeave * set guicursor=a:ver25

" highlight trailing whitespace
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

au BufEnter * set noro
let g:password = ""
function! s:sudowrite() abort
	let path = expand('%:p')
	let options = extend({'cmdarg': v:cmdarg, 'cmdbang': v:cmdbang, 'range': ''}, {})
	let tempfile = tempname()
	try
		execute(printf('%swrite%s %s %s', options.range, options.cmdbang ? '!' : '', options.cmdarg, tempfile))
		try
			call inputsave()
			if g:password == ""
				let g:password = inputsecret(printf('[sudo] %s password: ', $USER))
			endif
		finally
			call inputrestore()
		endtry
		let result = system(printf('printf ''%s\n'' | sudo -p '''' -sS dd if=%s of=%s bs=1048576', g:password, shellescape(tempfile), shellescape(path)))
		if v:shell_error
			throw result
		endif
	finally
		silent call delete(tempfile)
	endtry
endfunction
command! W call s:sudowrite()

" jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" --- Custom Shortcuts ---
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <F2> :NERDTreeToggle<CR>
inoremap <A-i> <ESC>:Format<CR>
nnoremap <A-i> <ESC>:Format<CR>
inoremap <C-d> <ESC>viw<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" move line or visually selected block - alt+j/k
noremap <A-j> :m .+1<CR>==
noremap <A-k> :m .-2<CR>==
noremap <A-down> :m .+1<CR>==
noremap <A-up> :m .-2<CR>==
" comment shortcuts
inoremap <A-c> <ESC>:call nerdcommenter#Comment('n', 'Toggle')<CR>
inoremap <C-A-c> <ESC>:call nerdcommenter#Comment('n', 'Invert')<CR>
for m in ['n', 'v']
	for s in [['<A-c>', ':call nerdcommenter#Comment(''n'', ''Toggle'')<CR>'],
					\ ['<C-A-c>', ':call nerdcommenter#Comment(''n'', ''Invert'')<CR>'],
					\ ['<S-A-c>', ':call nerdcommenter#Comment(''n'', ''Comment'')<CR>']]
		execute m.'noremap' s[0] s[1]
	endfor
endfor

