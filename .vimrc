set t_Co=256

" neoBundle の設定
set nocompatible
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/neobundle.vim.git
endif
call neobundle#rc(expand('~/.vim/bundle'))

"NeoBundle 'git://github.com/Shougo/clang_complete.git'
"NeoBundle 'git://github.com/Shougo/echodoc.git'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
"NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
"NeoBundle 'git://github.com/Shougo/vim-vcs.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/Shougo/vinarise.git'
NeoBundle 'git://github.com/mattn/gist-vim.git'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'git://github.com/Lokaltog/vim-easymotion.git'
" ステータスラインをカッコよくする
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'ujihisa/unite-colorscheme'

" solarized カラースキーム
NeoBundle 'altercation/vim-colors-solarized'
" mustang カラースキーム
NeoBundle 'croaker/mustang-vim'
" wombat カラースキーム
NeoBundle 'jeffreyiacono/vim-colors-wombat'
" jellybeans カラースキーム
NeoBundle 'nanotech/jellybeans.vim'
" lucius カラースキーム
NeoBundle 'vim-scripts/Lucius'
" zenburn カラースキーム
NeoBundle 'vim-scripts/Zenburn'
" mrkn256 カラースキーム
NeoBundle 'mrkn/mrkn256.vim'
" railscasts カラースキーム
NeoBundle 'jpo/vim-railscasts-theme'
" pyte カラースキーム
NeoBundle 'therubymug/vim-pyte'
" molokai カラースキーム
NeoBundle 'tomasr/molokai'

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
" vim-pureline使わない場合
" ステータスライン
" set laststatus=2 
" set statusline=%F%m%r%h%w\ %LLine\ [%p%%]
"
" augroup InsertHook
" autocmd!
" autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
" autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
" augroup END

" Syntax Color
syntax on
set background=dark
"colorscheme desert
colorscheme mrkn256

set number
set ruler
set wrap
set backspace=2
set ai
set showmatch
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932


" ---- vimfiler の設定 ---
"
" とりあえずF2でファイラー起動
nnoremap <F2> :VimFiler -buffer-name=explorer -split -winwidth=45 -toggle -no-quit<Cr>

autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

let my_action = { 'is_selectable' : 1 }
function! my_action.func(candidates)
  wincmd p
  exec 'split '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_split', my_action)

let my_action = { 'is_selectable' : 1 }                     
function! my_action.func(candidates)
  wincmd p
  exec 'vsplit '. a:candidates[0].action__path
endfunction
call unite#custom_action('file', 'my_vsplit', my_action)

" マウスを有効に
if has('mouse')
    set mouse=a
endif

"------- ここからコピペ ---------


"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
"set list              " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast


"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" vim-powerlineでフォントにパッチを当てないなら以下をコメントアウト
let g:Powerline_symbols = 'fancy'

"ステータスラインに文字コードと改行文字を表示する
" if winwidth(0) >= 120
  " set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %{g:HahHah()}\ %F%=[%{GetB()}]\ %{fugitive#statusline()}\ %l,%c%V%8P
" else
  " set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %{g:HahHah()}\ %f%=[%{GetB()}]\ %{fugitive#statusline()}\ %l,%c%V%8P
" endif

"入力モード時、ステータスラインのカラーを変更
" augroup InsertHook
" autocmd!
" autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340 ctermfg=cyan
" autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=white
" augroup END

"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

