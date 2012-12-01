## Environment variable configuration

# MacとLinuxで設定を振り分ける
case "$OSTYPE" in
# BSD (contains Mac)
darwin*)
  # perlbrew
  source $HOME/perl5/perlbrew/etc/bashrc
  # kaoriya vimエイリアス
  alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias gvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
 
  # alias 
  alias o='open'
  alias ls='ls -hGp'
  alias la='ls -ahGp'
  alias ld='ls -ahGp | grep /'
  alias ll='ls -ahGlp'
  alias lld='ls -ahGlp | grep /'
  ;;  

# for GNU
linux*)
# lsに色を付ける
  
  alias ls='ls -hp --color=auto'
  alias la='ls -ahp --color=auto'
  alias ld='ls -ahp --color=auto | grep /'
  alias ll='ls -ahlp --color=auto'
  alias lld='ls -ahlp --color=auto | grep /'
  ;;  
esac

# LANG
export LANG=ja_JP.UTF-8

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# Groovy文字化け対策
export JAVA_OPTS='-Dgroovy.source.encoding=UTF-8 -Dfile.encoding=UTF-8'

# Grepにヒットした文字をハイライト
export GREP_OPTIONS='--color=auto'

# bashrcから取ってきた
export CLICOLOR=1

# Set shell options     #####################
# 有効にしてあるのは副作用の少ないもの
setopt auto_cd auto_remove_slash auto_name_dirs
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys pushd_ignore_dups
# 便利だが副作用の強いものはコメントアウト
#setopt auto_menu  correct rm_star_silent sun_keyboard_hack
#setopt share_history inc_append_history

# ------
# デフォルトの補完機能を有効
autoload -U compinit
compinit

# プロンプトのカラー表示を有効
autoload -U colors
colors

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# alias
function ggl() {
	w3m "http://www.google.co.jp/search?hl=ja&lr=lang_ja&q=$1"
}

# Git alias
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

# VCS settings
autoload -Uz vcs_info
precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
PROMPT=$'%2F%n@%m%f %3F%~%5F%1v%f %f%# '

