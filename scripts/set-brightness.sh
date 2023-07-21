#!/bin/zsh

if [[ $# -ne 1 ]]; then
	echo "$0 <0--1 (brightness value)>"
fi

brightness=$(( ${1} * 24242 ))
echo "Brightness int is $brightness"
echo ${brightness%.*} | sudo tee /sys/class/backlight/intel_backlight/brightness
