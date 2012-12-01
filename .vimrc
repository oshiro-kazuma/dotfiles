
" neoBundle の設定
set nocompatible
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/neobundle.vim.git
endif
call neobundle#rc(expand('~/.vim/bundle'))

"NeoBundle 'git://github.com/Shougo/clang_complete.git'
"NeoBundle 'git://github.com/Shougo/echodoc.git'
"NeoBundle 'git://github.com/Shougo/neocomplcache.git'
"NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
"NeoBundle 'git://github.com/Shougo/vim-vcs.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/Shougo/vinarise.git'
NeoBundle 'git://github.com/mattn/gist-vim.git'

filetype plugin on
filetype indent on

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" 拡張子の設定
autocmd BufNewFile,BufRead *.twig set filetype=php
autocmd BufNewFile,BufRead *.cpt set filetype=php

" vim基本設定
set cindent
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimbackup
set clipboard=unnamed
set nocompatible
set incsearch
set number
set tabstop=4
set showmatch
set smartcase
set smartindent
set whichwrap=b,s,h,l,<,>,[,]
set nowrapscan
au BufNewFile,BufRead * set iminsert=0
au BufNewFile,BufRead * set tabstop=4 shiftwidth=4

" status color
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" Syntax Color
syntax on
set background=dark
colorscheme desert

" ステータスライン周り
set laststatus=2 
set statusline=%F%m%r%h%w\ %LLine\ [%p%%]

set number
set ruler
set wrap
set backspace=2
set ai
set showmatch
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8

" とりあえずF2でファイラー起動
nnoremap <F2> :VimFiler -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>

