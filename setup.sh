#!/bin/sh
# カレントディレクトリにある.ファイルのシンボリックリンクをhomeにはる
for dotfile in .[!.]?*
do
  # .gitはスルー
  if [ $dotfile = '.git' ]
  then
    continue
  fi
  ln -Fis "$PWD/$dotfile" $HOME
done

mkdir -p $HOME/.zsh_plugin/ && cd $HOME/.zsh_plugin/
git clone git://github.com/zsh-users/zaw.git
