#!/bin/bash

LOAD_DIR="$(cd "$(dirname "$0")" && pwd)"
# We expect that the checks and installation utils have already been loaded.
if [[ -z $__INSTALLATION_CHECKS ]]; then
	echo "Need to have sourced __installation_checks.sh"
	exit 1
fi

if [[ -z $__SOURCE_LOCATIONS ]]; then
	echo "Need to have sourced __source_locations.sh"
	exit 1
fi

install_mu_prereqs() {
	check_sudo
	# Install deps
	sudo apt install libgmime-3.0-0 libgmime-3.0-dev libxapian-dev
}

install_mu() {
	# Get mu
	if [[ ! -d $MU_LOCATION ]]; then
		git clone git://github.com/djcb/mu.git $MU_LOCATION
	else
		pushd $MU_LOCATION
		git pull
		popd
	fi

	echo "Building Mu"
	pushd $MU_LOCATION
	./autogen.sh
	make
	sudo make install
	popd
}

install_vim_prereqs() {
	check_sudo

	# These are taken from a stackoverflow question about enabling clientserver
	# and the YCM installation guide.  They have just been combined.
	sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
		python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git \
		libncurses5-dev libgnome2-dev libgnomeui-dev \
	    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
	    libcairo2-dev libx11-dev libxpm-dev libxt-dev
}

update_vim() {
	install_vim_prereqs

	if [[ ! -d "$VIM_SOURCE_LOCATION/vim" ]]; then
		mkdir -p "$VIM_SOURCE_LOCATION"
		pushd "$VIM_SOURCE_LOCATION"
		# And clone:
		git clone https://github.com/vim/vim
		popd
	fi

	# Expect these to have one result.  They will fail
	# the next test if there is more than one result.
	python2_config_dir=(/usr/lib/python2.*/config*)
	python3_config_dir=(/usr/lib/python3.*/config*)

	if [[ ! -d "$python2_config_dir" ]]; then
		echo "Python directory $python2_config_dir doesn't exist... Can you fix me?"
		exit 1
	fi

	if [[ ! -d "$python3_config_dir" ]]; then
		echo "Python directory $python3_config_dir doens't exist... Can you fix me?"
		exit 1
	fi

	# Go to the vim source directory:
	pushd "$VIM_SOURCE_LOCATION/vim"
	git pull origin master:master
	make distclean
	./configure --with-features=huge \
		--enable-multibyte \
		--enable-rubyinterp=yes \
		--enable-pythoninterp=yes \
		--with-python-command=$(which python) \
		--with-python-config-dir=$python2_config_dir \
		--enable-python3interp=yes \
		--with-python3-command=$(which python3) \
		--with-python3-config-dir=$python3_config_dir \
		--enable-perlinterp=yes \
		--enable-luainterp=yes \
		--enable-gui=gtk2 \
		--enable-cscope

	# Make
	make -j8

	# Backup the old vim if it still exists.
	# Only keep one version, the idea is that if something
	# is really wrong, vim.old can be used for a while
	# until it is fixed.
	if [ -f /usr/local/bin/vim ]; then
		sudo mv /usr/local/bin/vim /usr/local/bin/vim.old
	fi

	sudo make install -j8

	popd
}
