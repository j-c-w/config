#!/bin/bash
# Run this from within the config directory
# The default is to install /all/ things. If an argument is specified,
# only that is installed. Multiple arguements may be specified and 
# multiple things will be installed.

set -u

# Adding things to this file:
#	1. Add an enabled variable for it at the top.
#	2. Add a function to install it, making sure to check
#		for the correct dependencies
#	3. Add --program and --no-program options
#	4. At the very bottom, add a '( should_install $VAR_NAME ) && function_name

ALL=1

SMALL_MODE=0
ENABLE_MODE=0
DISABLE_MODE=0
VUNDLE=0
VIM_PLUGINS=0
OH_MY_ZSH=0
OH_MY_ZSH_PLUGINS=0
RC_LINK=0
NIXOS_FILES=0
POWERLINE=0
YOU_COMPLETE_ME=0
VIM=0
RIPGREP=0
PAPIS=0
EMAIL=0

# Import the script folder.
LOAD_DIR="$(cd "$(dirname "$0")" && pwd)"
# Checks that various required programs are installed.
source "$LOAD_DIR/scripts/__installation_checks.sh"
# Contains the locations for source programs to be installed
# into.
source "$LOAD_DIR/scripts/__source_locations.sh"
# Stores some functions to install things (eg. vim).
source "$LOAD_DIR/scripts/update_functions.sh"

usage() {
	echo "Usage: $0 home_directory [options]"
	echo "(--help for more details)"
}

help() {
	cat <<EOF
	Usage: $0 home_directory [options]
	Default is to install everthing. To not install everything by default
	and specify bits and peices to be installed, use the
	following options:
		--vundle: install vundle

		--vim-plugins: install vim plugins

		--vim: Build a local vim installation.

		--oh-my-zsh: install oh-my-zsh

		--oh-my-zsh-plugins: install oh-my-zsh-plugins

		--rc-link: Link .vimrc to ~/.vimrc, .zshrc to ~/.zshrc,
					.vimrc_additions to ~/.vimrc_additions

		--nixos-files: Gets the nixfiles repositories I use
				and links them under /etc/nixos/nixfiles

		--powerline: Install powerline font

		--you-complete-me: Install you complete me.

		--ripgrep: Install ripgrep

		--papis: Install papis

		--email: Install an email server and download all of my emails.

	Each option comes with a disable mode to selectively disable.
	These should not be used in conjunction with the enable mode!

	The disable mode is as above, but with a 'no-' prefixed e.g.

		--no-vundle

	By default, all plugins will then be installed, with vundle
	(and any others specified) not installed.
EOF
}

oh_my_zsh_install() {
	check_git
	check_zsh
	cd $home_directory
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	cd .oh-my-zsh/plugins
	echo $(pwd)
	cd ~

	echo "------------------------------"
	echo "ohmyzsh installed"
	echo "------------------------------"
}

oh_my_zsh_plugins_install() {
	# Pull the plugins
	check_git
	pushd $home_directory/.oh-my-zsh/plugins
	git clone https://github.com/zsh-users/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions
	git clone https://github.com/chisui/zsh-nix-shell.git nix-shell
	git clone https://github.com/spwhitt/nix-zsh-completions
	popd

	echo $(pwd)

	echo "------------------------------"
	echo "ohmyzsh plugins installed"
	echo "------------------------------"
}

vundle_install() {
	# Now, insatll Vundle:
	check_git
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


	echo "------------------------------"
	echo "Vundle installed"
	echo "------------------------------"
}

rc_link() {
	rm -f ~/.vimrc
	rm -f ~/.vimrc_additions
	rm -f ~/.zshrc
	rm -f ~/.emacs
	rm -f ~/.offlineimaprc
	rm -f ~/.offlineimap.py
	# Note this is not recursive because a softlink is a file.
	rm -f ~/.passwd
	rm -f ~/.scripts
	rm -f ~/.config/i3/config
	rm -f ~/.tmux.conf
	rm -f ~/.config/papis/config

	ln -s $config_directory/.vimrc ~/.vimrc 
	ln -s $config_directory/.vimrc_additions ~/.vimrc_additions 
	ln -s $config_directory/.zshrc ~/.zshrc
	ln -s $config_directory/.tmux.conf ~/.tmux.conf
	ln -s $config_directory/.emacs ~/.emacs
	ln -s $config_directory/.offlineimaprc ~/.offlineimaprc
	ln -s $config_directory/.offlineimap.py ~/.offlineimap.py
	ln -s $config_directory/.passwd ~/.passwd
	# Also link the local scripts.
	ln -s $config_directory/scripts ~/.scripts
	# Also link the i3 config.  If i3 isn't installed
	# that should be OK, although this might have to be
	# re-run after it is installed (and presumably overwritten)
	mkdir -p ~/.config/i3
	ln -s $config_directory/i3_config ~/.config/i3/config

	# A similar argument holds for the papis config file.
	mkdir -p ~/.config/papis
	ln -s $config_directory/papis_config ~/.config/papis/config

	echo "-------------------------------"
	echo "Config files linked"
	echo "-------------------------------"
}

nixos_files() {
	sudo mkdir -p /etc/nixos/nixfiles

	git submodule init
	git submodule update

	sudo ln -s $PWD/nixos-hardware /etc/nixos/nixfiles
}

email_install() {
	check_git
	check_make
	check_offlineimap

	sudo apt install libgmime-3.0-dev libxapian-dev texinfo

	# Get offlineimap and install it.  It needs to
	# be run after linking the RCs, so also do that.
	(nohup offlineimap &)
	echo "Starting to run offlineimap.  This may take some time to complete but will be done in the background."
	sleep 2

	install_mu
}

vim_install() {
	check_git
	check_make

	mkdir -p $VIM_SOURCE_LOCATION

	# FIXME: would be nice to go to the last major release?
	update_vim
}

ripgrep_install() {
	mkdir -p $RIPGREP_LOCATION

	# FIXME: would be nice to get a recent release?
	wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz -O $RIPGREP_LOCATION/ripgrep.tar.gz || exit 1

	pushd $RIPGREP_LOCATION
	tar -xzf ripgrep.tar.gz
	# Now, create a symlink:
	sudo rm -f /usr/local/bin/rg
	sudo ln -s $RIPGREP_LOCATION/ripgrep-0.10.0-x86_64-unknown-linux-musl/rg /usr/local/bin/rg
	popd
}

you_complete_me_install() {
	check_python
	# Note that this must be run _after_ installing
	# Vundle and running the vim install phase.

	pushd ~/.vim/VundlePlugins/YouCompleteMe || (echo "Error -- install vim plugins first"; exit 1)
	./install.py --clang-completer --java-completer

	popd
}

powerline_install() {
	# Finally, install powerline:
	check_pip

	pip install --user git+git://github.com/Lokaltog/powerline

	wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
	fc-cache -vf ~/.fonts
	mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/


	echo "------------------------------"
	echo "powerline installed"
	echo "------------------------------"
}

vim_plugins_install() {
	# Now install the vim plugins:
	check_git

	vim -E -c BundleInstall -c qall
}

papis_install() {
	check_pip3
	check_python3
	sudo pip3 install whoosh
	sudo pip3 install setuptools
	sudo apt install qpdfview

	# Build and install papis from my personal repo.
	# If my requested changes get merged then I'll migrate
	# to the main repo.
	if [[ -d ~/.papis_install ]]; then
		echo "Not installing papis because ~/.papis_install already exists."
		echo "Delete this folder if you want to install papis again."
		return
	fi
	git clone https://github.com/j-c-w/papis ~/.papis_install
	pushd ~/.papis_install
	sudo python3 setup.py install
	sudo make && sudo make install
	popd

	# Make all the papis folders
	mkdir -p ~/Documents/papers ~/Documents/software ~/Documents/latex  ~/Documents/latex ~/Documents/recipes ~/Documents/running_papers

	# Init the papis git repository.
	papis git init
	papis git remote add origin git@github.com:j-c-w/papers
	papis -l running git init
	papis -l software git init
	papis -l latex git init
	papis -l recipes git init

	papis -l running git remote add origin git@github.com:j-c-w/running_papers
	papis -l software git remote add origin git@github.com:j-c-w/software_documentation
	papis -l latex git remote add origin git@github.com:j-c-w/latex
	papis -l recipes git remote add origin git@github.com:j-c-w/recipes
}

should_install() {
	plugin_enabled=$1

	[ $ENABLE_MODE -eq 1 ] && [ $plugin_enabled -eq 1 ] && return 1
	[ $DISABLE_MODE -eq 1 ] && [ $plugin_enabled -ne 0 ] && return 1

	return $ALL
}

config_directory=$(pwd)

if [ "$#" -lt 1 ]; then
	usage
	exit 1
fi

if [[ $1 =~ "-h|--help" ]]; then
	help
	exit 0
fi

if [ ! -d "$1" ]; then
	usage
	exit 1
fi

home_directory=$1
shift

while [ $# -gt 0 ]
do
	key="$1"
	ALL=0

	case $key in
		--small)
			SMALL_MODE=1
			;;
		--vundle)
			ENABLE_MODE=1
			VUNDLE=1
			;;
		--no-vundle)
			DISABLE_MODE=1
			VUNDLE=0
			;;
		--vim-plugins)
			ENABLE_MODE=1
			VIM_PLUGINS=1
			;;
		--no-vim-plugins)
			DISABLE_MODE=1
			VIM_PLUGINS=0
			;;
		--oh-my-zsh)
			ENABLE_MODE=1
			OH_MY_ZSH=1
			;;
		--no-oh-my-zsh)
			DISABLE_MODE=1
			OH_MY_ZSH=0
			;;
		--oh-my-zsh-plugins)
			ENABLE_MODE=1
			OH_MY_ZSH_PLUGINS=1
			;;
		--no-oh-my-zsh-plugins)
			DISABLE_MODE=1
			OH_MY_ZSH_PLUGINS=0
			;;
		--rc-link)
			ENABLE_MODE=1
			RC_LINK=1
			;;
		--no-rc-link)
			DISABLE_MODE=1
			RC_LINK=0
			;;
		--nixos-files)
			ENABLE_MODE=1
			NIXOS_FILES=1
			;;
		--no-nixos-files)
			DISABLE_MODE=1
			NIXOS_FILES=0
			;;
		--powerline)
			ENABLE_MODE=1
			POWERLINE=1
			;;
		--no-powerline)
			DISABLE_MODE=1
			POWERLINE=0
			;;
		--you-complete-me)
			ENABLE_MODE=1
			YOU_COMPLETE_ME=1
			;;
		--no-you-complete-me)
			DISABLE_MODE=1
			YOU_COMPLETE_ME=0
			;;
		--vim)
			ENABLE_MODE=1
			VIM=1
			;;
		--no-vim)
			DISABLE_MODE=1
			VIM=0
			;;
		--ripgrep)
			ENABLE_MODE=1
			RIPGREP=1
			;;
		--no-ripgrep)
			DISABLE_MODE=1
			RIPGREP=0
			;;
		--papis)
			ENABLE_MODE=1
			PAPIS=1
			;;
		--no-papis)
			DISABLE_MODE=1
			PAPIS=0
			;;
		--email)
			ENABLE_MODE=1
			EMAIL=1
			;;
		--no-email)
			DISABLE_MODE=1
			EMAIL=0
			;;
		-h|--help)
			help
			exit 0
			;;
		*)
			echo "Unrecognized option $key"
			exit 1
			;;
	esac
	shift # past argument or value
done

if [ $DISABLE_MODE -eq 1 ] && [ $ENABLE_MODE -eq 0 ]; then
	# Both a --no-* and a --* option were used.
	# That doesn't make much sense, so fail.
	echo "Error: Both a --no-X and a --Y option were used"
	exit 1
fi

if [[ $SMALL_MODE == 1 ]] && ( [[ $DISABLE_MODE == 1 ]] || [[ $ENABLE_MODE == 1 ]] ); then
	echo "Error: --small is a predefined set of installations.  It skips complicated"
	echo "and long steps like installing the  email client and just quickly sets things up"
	exit 1
fi

if [[ $SMALL_MODE == 1 ]]; then
	# Install just the quicker things.
	ENABLE_MODE=1
	VUNDLE=1
	OH_MY_ZSH=1
	OH_MY_ZSH_PLUGINS=1
	POWERLINE=1
	RC_LINK=1
	NIXOS_FILES=1
	VIM=1
	VIM_PLUGINS=1
	RIPGREP=1
	PAPIS=1
fi

( should_install $VUNDLE ) || vundle_install
( should_install $OH_MY_ZSH ) || oh_my_zsh_install
( should_install $OH_MY_ZSH_PLUGINS ) || oh_my_zsh_plugins_install
( should_install $POWERLINE ) || powerline_install
( should_install $RC_LINK ) || rc_link
( should_install $NIXOS_FILES ) || nixos_files
( should_install $VIM ) || vim_install
( should_install $VIM_PLUGINS ) || vim_plugins_install
( should_install $YOU_COMPLETE_ME ) || you_complete_me_install
( should_install $RIPGREP ) || ripgrep_install
( should_install $PAPIS ) || papis_install
( should_install $EMAIL ) || email_install

echo "Done!"
