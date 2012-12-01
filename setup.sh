#!/bin/sh

for dotfile in .[!.]?*
do
	# .gitはスルー
	if [ $dotfile = '.git' ]
	then
		continue
	fi
	
	ln -s "./$dotfile" $HOME

done
