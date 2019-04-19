"vim-airline
"set ft=tmux

" Activate vim only features
set nocompatible

" Set a few core features
set encoding=utf-8
set ruler
set number
set relativenumber
set cursorline
set nowrap
set backspace=indent,eol,start
set wildmenu

" Search options
set hlsearch
set incsearch
set ignorecase
set smartcase

" Some indentation settings
set shiftwidth=4
set tabstop=4
set expandtab

" Always show status line
set laststatus=2

set t_Co=256

" Show maximum text width
set colorcolumn=80
"set textwidth=80

" Split windows accordingly
set splitbelow
set splitright

set mouse=n
set foldmethod=marker
set directory^=$HOME/.vim/swapfiles//
set listchars=tab:»·,trail:·,nbsp:· list

set noerrorbells
set showcmd
set showmode
set autoindent
set showmatch
set smarttab

set scrolloff=5
set scrolloff=5

set complete=.,w,b,u,t

" Spell checking
set spelllang=en,de
"set spell

" Enable syntax highlighting without overwriting colors
syntax on

command E Explore

" If saving as w!!, vim will force-save the file with sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

filetype plugin indent on
let maplocalleader="\\"
let g:html_indent_tags = 'li\|p'

" Window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>i
nnoremap <C-Delete> :tabclose<CR>i

nnoremap <C-o> :NERDTreeToggle<CR>

" Have german Umlauts
"inoremap ae ä
"inoremap oe ö
"inoremap ue ü
"inoremap Ae Ä
"inoremap Oe Ö
"inoremap Ue Ü

" Remove trailing whitespace on saving
autocmd BufWritePre * %s/\s\+$//e

" Install vim-plug if not available
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:lightline = {
\   'active': {
\     'left':[ [ 'mode', 'paste' ],
\              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
\     ]
\   },
\   'component': {
\     'lineinfo': ' %3l:%-2v',
\   },
\   'component_function': {
\     'gitbranch': 'fugitive#head',
\   }
\ }
let g:lightline.separator = {
\   'left': '', 'right': ''
\}
let g:lightline.subseparator = {
\   'left': '', 'right': ''
\}

let g:lightline.tabline = {
\   'left': [ ['tabs'] ],
\   'right': [ ['close'] ]
\ }
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline

call plug#begin('~/.vim/plugged')

    " Looks
    Plug 'itchyny/lightline.vim'
    Plug 'sjl/badwolf'
    Plug 'reedes/vim-colors-pencil'

    " Extra functionality
    Plug 'scrooloose/nerdtree'
    Plug 'w0rp/ale'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'scrooloose/nerdcommenter'
    Plug 'ervandew/supertab'
    Plug 'junegunn/fzf.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'junegunn/goyo.vim'

    " "Todo
    Plug 'freitass/todo.txt-vim', { 'for': 'todo' }

    " Markdown
    Plug 'dhruvasagar/vim-table-mode'

    Plug 'vim-scripts/deb.vim'
    Plug 'mboughaba/i3config.vim'
    Plug 'LnL7/vim-nix'
    Plug 'tomtom/tcomment_vim'
"    Plug 'Valloric/YouCompleteMe'
"    Plug 'janko-m/vim-test'

"    Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
"    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

colorscheme badwolf

function! s:goyo_enter()
    colorscheme pencil
endfunction

function! s:goyo_leave()
    colorscheme badwolf
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
