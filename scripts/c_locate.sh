#!/bin/bash

function is_dir() {
	while read data; do
		if [[ -d $data ]]; then
			echo $data
		fi
	done <<< $(locate  -r "$@")
}

if [[ $# == 0 ]]; then
	args=".*"
else
	args="$@"
fi

is_dir "$args" | fzf
