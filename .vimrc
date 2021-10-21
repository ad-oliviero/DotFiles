set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/plugged')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Colorschemes
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'cocopon/iceberg.vim'
Plugin 'arcticicestudio/nord-vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'sjl/badwolf'
Plugin 'lifepillar/vim-solarized8'
Plugin 'scheakur/vim-scheakur'
Plugin 'Badacadabra/vim-archery'

" Other plugins
Plugin 'sheerun/vim-polyglot'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'derekwyatt/vim-protodef'
" List ends here. Plugins become visible to Vim after this call.
call vundle#end()
filetype plugin indent on

" auto-pairs configuration
let g:AutoPairsShortcutToggle = '<C-P>'

" NERDTree configuration
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalMenu = 1
let NERDTreeWinPos = "left"
let NERDTreeWinSize = 31

" tagbar configuration
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'

" fswitch configuration
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h'
au! BufEnter *.h   let b:fswitchdst = 'cpp,c'

" vim-protodef configuration 
nmap <buffer> <silent> <leader> ,PP
nmap <buffer> <silent> <leader> ,PN
let g:disable_protodef_sorting = 1

" Vim configuration
set nu                  " Enable line numbers
set relativenumber      " Enable relative line numbers
syntax on               " Enable synax highlighting
set incsearch           " Enable incremental search
set hlsearch            " Enable highlight search
set splitbelow          " Always split below
set mouse=a             " Enable mouse drag on window splits
set tabstop=2           " How many columns of whitespace a \t is worth
set shiftwidth=2        " How many columns of whitespace a “level of indentation” is worth
" set expandtab           " Use spaces when tabbing

if !has('nvim')
    set termwinsize=12x0    " Set terminal size
endif


"let ayucolor="mirage"
"colorscheme ayu
set background=dark     " Set background 
colorscheme scheakur    " Set color scheme

" Key mappings

nmap        <C-B>     :buffers<CR>
nmap        <C-J>     :term<CR>
nmap        <F2>      :NERDTreeToggle<CR>
nmap        <F8>      :TagbarToggle<CR>
nmap        <C-s>     :w<CR>
nmap        <C-q>     :wq!<CR>

" custom commands
command -nargs=0 W :w !sudo tee %
command -nargs=0 WQ :wq !sudo tee %
