set nocompatible
set encoding=utf-8
filetype on
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/plugged')
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
Plugin 'morhetz/gruvbox'

" Other plugins
Plugin 'sbdchd/neoformat'
Plugin 'rhsyd/vim-clang-format'
Plugin 'sheerun/vim-polyglot'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'derekwyatt/vim-protodef'
Plugin 'rhysd/vim-clang-format'
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

" tagbar configuration
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'

let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"

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
filetype indent on      " Idk
set smartindent         " Enable smart indentation
set tabstop=2           " How many columns of whitespace a \t is worth
set shiftwidth=2        " How many columns of whitespace a “level of indentation” is worth
" set expandtab           " Use spaces when tabbing
set softtabstop=2       " Too long to explain, go on google and find it yourself
set ruler
set cul

let &t_SI .= "\<Esc>[5 q"
let &t_EI .= "\<Esc>[3 q"
autocmd VimLeave * silent !echo -ne "\033]112\007"
autocmd BufWritePre *.c ClangFormat
autocmd BufWritePre *.cpp ClangFormat

"let ayucolor="mirage"
"colorscheme ayu
set background=dark     " Set background 
" colorscheme scheakur    " Set color scheme
colorscheme gruvbox


" Key mappings
nmap        <C-B>       :buffers<CR>
nmap        <C-J>       :term<CR>
nmap        <F2>        :NERDTreeToggle<CR>
nmap        <F8>        :TagbarToggle<CR>
nmap        <C-s>       :w<CR>
nmap        <C-q>       :q!<CR>
nmap        tp          :tabprev<CR>
nmap        tn          :tabnext<CR>
nmap        tc          :tabclose<CR>
nmap        tt          :tabnew<CR>
nmap        <F5>        :!make!<CR>

" custom commands
command -nargs=0 W :w !sudo tee %
command -nargs=0 WQ :wq !sudo tee %
command -nargs=0 Make !make!

