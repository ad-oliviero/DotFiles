set nocompatible
set encoding=utf-8
filetype on
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/plugged')
Plugin 'VundleVim/Vundle.vim'

" Colorschemes
Plugin 'ayu-theme/ayu-vim'
Plugin 'morhetz/gruvbox'

" Other plugins
Plugin 'sbdchd/neoformat'
Plugin 'rhsyd/vim-clang-format'
Plugin 'sheerun/vim-polyglot'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'derekwyatt/vim-protodef'
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
let NERDTreeWinSize = 32

" vim-protodef configuration 
nmap <buffer> <silent> <leader> ,PP
nmap <buffer> <silent> <leader> ,PN
let g:disable_protodef_sorting = 1

" Vim configuration
set nu                  " Enable line numbers
" set relativenumber    " Enable relative line numbers
syntax on               " Enable synax highlighting
set incsearch           " Enable incremental search
set hlsearch            " Enable highlight search
set splitbelow          " Always split below
set mouse=v             " Enable mouse drag on window splits
" set smartindent       " Enable smart indentation
set tabstop=2           " How many columns of whitespace a \t is worth
set shiftwidth=2        " How many columns of whitespace a “level of indentation” is worth
" set expandtab         " Use spaces when tabbing
set softtabstop=2       " Too long to explain, go on google and find it yourself
set ruler
set clipboard=unnamed
set cul

" filetype system
filetype on
filetype plugin on
filetype indent on

" cursor
autocmd VimLeave * call system('printf "\e[4 q" > $TTY')
autocmd VimEnter * call system('printf "\e[3 q" > $TTY')
let &t_SI .= "\<Esc>[5 q"
let &t_EI .= "\<Esc>[3 q"

"let ayucolor="mirage"
"colorscheme ayu
set background=dark     " Set background 
" colorscheme scheakur    " Set color scheme
colorscheme gruvbox


" Key mappings
nmap        <C-B>       :buffers<CR>
nmap        <C-J>       :term<CR>
nmap        <F2>        :NERDTreeToggle<CR>
nmap        <C-s>       :w<CR>
nmap        <C-w>       :q<CR>
nmap				<C-q>				:qa<CR>
nmap				<C-a>				ggVG
nmap				<C-c>				Vy
nmap        <C-i>       :tabnext<CR>
nmap        <C-t>       :tabnew<CR>

" custom commands
command -nargs=0 W :w !sudo tee >/dev/null %

