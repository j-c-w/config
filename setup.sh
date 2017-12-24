#!/bin/bash
# Run this from within the config directory
# The default is to install /all/ things. If an argument is specified,
# only that is installed. Multiple arguements may be specified and 
# multiple things will be installed.

# Adding things to this file:
#	1. Add an enabled variable for it at the top.
#	2. Add a function to install it, making sure to check
#		for the correct dependencies
#	3. Add --program and --no-program options
#	4. At the very bottom, add a '( should_install $VAR_NAME ) && function_name

ALL=1

ENABLE_MODE=0
DISABLE_MODE=0
VUNDLE=0
VIM_PLUGINS=0
OH_MY_ZSH=0
OH_MY_ZSH_PLUGINS=0
RC_LINK=0
POWERLINE=0
YOU_COMPLETE_ME=0


usage() {
	echo "Usage: $0 home_directory [options]"
	echo "(--help for more details)"
}

help() {
	echo "Usage: $0 home_directory [options]"
	echo "Default is to install everthing. To not install everything by default"
	echo "and specify bits and peices to be installed, use the"
	echo "following options:"
	echo ""
	echo "	--vundle: install vundle"
	echo ""
	echo "	--vim-plugins: install vim plugins"
	echo ""
	echo "	--oh-my-zsh: install oh-my-zsh"
	echo ""
	echo "	--oh-my-zsh-plugins: install oh-my-zsh-plugins"
	echo ""
	echo "	--rc-link: Link .vimrc to ~/.vimrc, .zshrc to ~/.zshrc,"
	echo "				.vimrc_additions to ~/.vimrc_additions"
	echo ""
	echo "	--powerline: Install powerline font"
	echo ""
	echo "	--you-complete-me: Install you complete me."
	echo ""
	echo "Each option comes with a disable mode to selectively disable."
	echo "These should not be used in conjunction with the enable mode!"
	echo ""
	echo "The disable mode is as above, but with a 'no-' prefixed i.e."
	echo ""
	echo "	--no-vundle"
	echo ""
	echo "By default, all plugins will then be installed, with vundle"
	echo "(and any others specified) not installed."
}

# Exit prematurely if pip is not installed.
check_pip() {
	if [ command -v pip > /dev/null 2>&1 ]; then
		echo "pip not installed. Run 'sudo apt-get install pip' "
		exit 1
	fi
}

# Exit prematurely if git is not installed.
check_git() {
	if [command -v git > /dev/null 2>&1 ]; then
		echo "git not installed. Run 'sudo apt-get install git' "
		exit 1
	fi
}

# Return true if we have sudo, false otherwise
has_sudo() {
	if [[ $(id -u) > 0 ]]; then
		return 0
	else
		return 1
	fi
}

oh_my_zsh_install() {
	check_git
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
	git clone https://github.com/zsh-users/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions

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
	rm .vimrc
	rm .vimrc_additions
	rm .zshrc

	ln -s $config_directory/.vimrc .vimrc 
	ln -s $config_directory/.vimrc_additions .vimrc_additions 
	ln -s $config_directory/.zshrc .zshrc

	echo "-------------------------------"
	echo "Config files linked"
	echo "-------------------------------"
}

you_complete_me_install() {
	# Note that this must be run _after_ installing
	# Vundle and running the vim install phase.

	cd ~/.vim/VundlePlugins/YouCompleteMe || (echo "Error -- install vim plugins first"; exit 1)
	./install.py --clang-completer

	if has_sudo; then
		./install.py --tern-completer
	else
		echo "Rerun with 'sudo' to install javascript semantic support"
	fi

	cd -
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

	vim -E -c VundleInstall -c qall
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

( should_install $VUNDLE ) || vundle_install
( should_install $VIM_PLUGINS ) || vim_plugins_install
( should_install $OH_MY_ZSH ) || oh_my_zsh_install
( should_install $OH_MY_ZSH_PLUGINS ) || oh_my_zsh_plugins_install
( should_install $POWERLINE ) || powerline_install
( should_install $RC_LINK ) || rc_link
( should_install $YOU_COMPLETE_ME ) || you_complete_me_install

echo "Done!"
