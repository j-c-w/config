#!/bin/bash

if [[ $# == 0 ]]; then
	regex_str=".*"
else
	regex_str=".*$@.*" 
fi
fd -L --type d -p "$regex_str" | fzf
