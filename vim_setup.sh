#!/bin/sh

mkdir $HOME/.vimbackup
git clone git://github.com/Shougo/neobundle.vim ~/.vim/neobundle.vim.git

ln -Fis "$PWD/rc" $HOME/.vim
