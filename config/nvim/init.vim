" --- Plugins ---
lua require('config')

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
nnoremap <C-q> :tabn<CR>
nnoremap <C-S-q> :tabp<CR>
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

