#!/bin/zsh

typeset -a dir
zparseopts -D -E -- -dir:=dir d:=dir

if [[ ${#dir} -gt 0 ]]; then
	dirname="${dir[2]}"
	echo "Running c.sh command in $dirname"
	cd "$dirname"
fi

if [[ $# == 0 ]]; then
	regex_str=".*"
else
	regex_str=".*$@.*" 
fi
fd -L --type d -p "$regex_str" | fzf
