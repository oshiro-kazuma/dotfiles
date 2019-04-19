## Environment variable configuration

setopt GLOB_DOTS

# .binにパスを通す
PATH=$PATH:$HOME/.bin
export PATH="/usr/local/bin:$PATH"

# gopath
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# dircolorsが有効かどうか1
which dircolors > /dev/null 2>&1
WHICH_DIRCOLOR=$?

[ $WHICH_DIRCOLOR = 0 ] && eval `dircolors ~/.dir_colors -b`;

bindkey -e

#
# ---- 基本設定 ----
#
# LANG
export LANG=ja_JP.UTF-8
# Groovy文字化け対策
export JAVA_OPTS='-Dgroovy.source.encoding=UTF-8 -Dfile.encoding=UTF-8'
# Grepにヒットした文字をハイライト
export GREP_OPTIONS='--color=auto'
# bashrcから取ってきた
export CLICOLOR=1
# zsh: no matches found 対策
setopt nonomatch
#
# ---- Set shell options ----
#
# 有効にしてあるのは副作用の少ないもの
setopt auto_cd auto_remove_slash auto_name_dirs
setopt prompt_subst
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys pushd_ignore_dups
# 便利だが副作用の強いものはコメントアウト
#setopt auto_menu  correct rm_star_silent sun_keyboard_hack

#
# ---- History関連 ----
#
HISTFILE=~/.zsh_history

#メモリに保存される履歴の件数
export HISTSIZE=1000000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=1000000
# 履歴ファイルに時刻を記録
setopt extended_history
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# 開始と終了を記録
setopt EXTENDED_HISTORY
# 履歴の共有
#setopt share_history
# 重複したコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
# 履歴をインクリメンタルに追加
setopt share_history inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
autoload history-search-end
# 履歴検索機能のショートカット
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# プロンプトのカラー表示を有効
autoload -U colors
colors
# コマンド訂正
# setopt correct

# bindkey '^e' zaw-history

#
# ---- 補完関係の設定 ----
#
# デフォルトの補完機能を有効
autoload -U compinit
compinit
# 補完キー（Tab,  Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu
# 補完を素敵に
zstyle ':completion:*:default' menu select=1
# 補完に色を付ける
if [ $WHICH_DIRCOLOR = 0 ] ; then
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
  zstyle ':completion:*' list-colors di=34 fi=0
fi
# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# Bazaar激重対策
zstyle ':vcs_info:bzr:*' use-simple true

#
# ---- プロンプト関連の設定 ----
#
# VCS settings
autoload -Uz vcs_info
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
PROMPT=$'%2F%n@%m%f %3F%~%5F%1v%f %f%# '

#
# ----- alias関連 ------
#
# MacとLinuxで設定を振り分ける
case "$OSTYPE" in
# BSD (contains Mac)
# darwin* | freebsd*)
freebsd*)
  alias o='open'
  alias ls='ls -hGp'
  alias la='ls -ahGp'
  alias ld='ls -ahGp | grep /'
  alias ll='ls -ahGlp'
  alias lld='ls -ahGlp | grep /'
  ;;  

# for GNU
*)
  alias ls='ls -hp --color=auto'
  alias la='ls -ahp --color=auto'
  alias ld='ls -ahp --color=auto | grep /'
  alias ll='ls -ahlp --color=auto'
  alias lld='ls -ahlp --color=auto | grep /'

  ;;  
esac
alias lr='ls -ltr'

# Git alias
alias g='git'
alias pull='git pull'
alias push='git push'
alias gm='git commit -m"$*"'
alias gs="git status -s"
alias gst="git status"
alias gd="git diff"
alias br="git branch"
alias ga="git add ."
alias gh="git help"
alias gl="git log --graph --pretty='format:%C(yellow)%h%Creset %C(magenta)%cd%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset' --date=iso"
alias glog='git log --graph --decorate --pretty=format:"%ad [%cn] <c:%h t:%t p:%p> %n %Cgreen%d%Creset %s %n" --stat -p'
alias gls='git log --stat --summary'

# alias
function ggl() {
	w3m "http://www.google.co.jp/search?hl=ja&lr=lang_ja&q=$1"
}

# tmux statusline
#PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# zaw plugin
source $HOME/.zsh_plugin/zaw/zaw.zsh
source $HOME/.dotfiles/iterm2.zsh
export PATH="$HOME/.embulk/bin:$PATH"
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# peco ghq
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# peco history
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

PATH=$PATH:$HOME/bin/flutter/bin

eval "$(direnv hook zsh)"
