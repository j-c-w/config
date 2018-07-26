#!/bin/bash

set -eux

# Load the installation checks.
LOAD_DIR="$(cd "$(dirname "$0")" && pwd)"
# Checks that programs (e.g. git) are installed.
source "$LOAD_DIR/__installation_checks.sh"
# Locations for various source files.
source "$LOAD_DIR/__source_locations.sh"

check_git

update_vim() {
	# Go to the vim source directory:
	current_dir=$(pwd)

	cd "$VIM_SOURCE_LOCATION/vim"
	git pull origin master:master
	make -j8
	# Backup the old vim if it still exists.
	# Only keep one version, the idea is that if something
	# is really wrong, vim.old can be used for a while
	# until it is fixed.
	if [ -f /usr/local/bin/vim ]; then
		sudo mv /usr/local/bin/vim /usr/local/bin/vim.old
	fi

	sudo make install -j8

	cd $current_dir
}

if [ ! has_sudo ]; then
	echo "Need sudo to update"
	exit 1
fi

# This is a script to do updating.  It works for an aptitude-based system only
# right now, but could ideally be ammended.
sudo apt-get update && yes | sudo apt-get upgrade

sudo apt-get autoremove

# Update all the vim plugins.
vim -E -c BundleUpdate -c qall

# Update all the locally built software
update_vim
