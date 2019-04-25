#!/bin/bash

set -ux

if [[ $* != *--ignore-errors* ]]; then
	set -e
fi

# Load the installation checks.
LOAD_DIR="$(cd "$(dirname "$0")" && pwd)"
# Checks that programs (e.g. git) are installed.
source "$LOAD_DIR/__installation_checks.sh"
# Locations for various source files.
source "$LOAD_DIR/__source_locations.sh"
source "$LOAD_DIR/update_functions.sh"

check_git

if [ ! has_sudo ]; then
	echo "Need sudo to update"
	exit 1
fi

# This is a script to do updating.  It works for an aptitude-based system only
# right now, but could ideally be ammended.
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get autoremove

# Update all the python things:
# This, perhaps unsurprisingly, caused problems with python packages.
# pip list --outdated | cut -d ' ' -f 1 | xargs -n 1 sudo pip install --upgrade

# Update all the vim plugins.
vim -E -c BundleUpdate -c qall

# Update all the locally built software
update_vim
