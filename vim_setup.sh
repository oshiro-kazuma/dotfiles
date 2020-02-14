#!/bin/sh

mkdir $HOME/.vimbackup
mkdir $HOME/.vim
ln -Fis "$PWD/rc" $HOME/.vim/rc
