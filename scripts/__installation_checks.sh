#!/bin/bash

# This script exports some functions that can be used by other scripts.  These
# functions all check if something is installed or not.

# Exit prematurely if pip is not installed.
check_pip() {
	if [ ! -x "$(command -v pip)" ]; then
		echo "pip not installed. Run 'sudo apt install pip' "
		echo "Try running install_prereqs.sh"
		exit 1
	fi
}
export  check_pip

# Exit prematurely if git is not installed.
check_git() {
	if [ ! -x "$(command -v git)" ]; then
		echo "git not installed. Run 'sudo apt install git' "
		echo "Try running install_prereqs.sh"
		exit 1
	fi
}
export -f check_git

check_zsh() {
	if [ ! -x "$(command -v zsh)" ]; then
		echo "zsh not installed.  Run 'sudo apt install zsh'"
		echo "Try running install_prereqs.sh"
		exit 1
	fi
}
export -f check_zsh

check_offlineimap() {
	if [ ! -x "$(command -v offlineimap)" ]; then
		echo "offlineimap not installed.  Run 'sudo apt install offlineimap"
		echo "Try running install_prereqs.sh"
		exit 1
	fi
}
export -f check_offlineimap

# Exit prematurely if python is not installed.
check_python() {
	if [ ! -x "$(command -v python)" ]; then
		echo "python not installed.  Run 'sudo apt install python'"
		echo "Try running install_prereqs.sh"
		exit 1
	fi
}
export -f check_python

# Exit prematurely if make is not installed.
check_make() {
	if [ ! -x "$(command -v make)" ]; then
		echo "make not installed.  Run sudo apt install make"
		echo "Try running install_prereqs.sh"
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
