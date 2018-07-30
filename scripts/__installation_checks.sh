#!/bin/bash

# This script exports some functions that can be used by other scripts.  These
# functions all check if something is installed or not.

# Exit prematurely if pip is not installed.
check_pip() {
	if [ ! -x "$(command -v pip)" ]; then
		echo "pip not installed. Run 'sudo apt install pip' "
		exit 1
	fi
}
export  check_pip

# Exit prematurely if git is not installed.
check_git() {
	if [ ! -x "$(command -v git)" ]; then
		echo "git not installed. Run 'sudo apt install git' "
		exit 1
	fi
}
export -f check_git

# Exit prematurely if python is not installed.
check_python() {
	if [ ! -x "$(command -v python)" ]; then
		echo "python not installed.  Run 'sudo apt install python'"
		exit 1
	fi
}
export -f check_python

# Exit prematurely if make is not installed.
check_make() {
	if [ ! -x "$(command -v make)" ]; then
		echo "make not installed.  Run sudo apt install make"
		exit 1
	fi
}
export -f check_make

# Return true if we have sudo, false otherwise
has_sudo() {
	if [[ $(id -u) > 0 ]]; then
		return 0
	else
		return 1
	fi
}
export -f has_sudo

check_sudo() {
	if [ ! has_sudo ]; then
		echo "Need sudo. "
		exit 1
	fi
}
export -f check_sudo

# Export a flag to show this is loaded:
export __INSTALLATION_CHECKS=1
