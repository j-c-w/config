#!/bin/sh
# Run this from within the config directory

if [ "$#" -ne 1]; then
	echo "Usage: $0 Home_Directory" >&2
	exit 1
fi

if [ ! -d "$1$" ]; then
	echo "Home directory must exist" >&2
	exit 1
fi

# Need pip and git installed:
if [ command -v pip > /dev/null 2>&1 ]
	echo "pip not installed. Run 'sudo apt-get install pip' "
	exit 1
fi

if [command -v git > /dev/null 2>&1 ]
	echo "git not installed. Run 'sudo apt-get install git' "
	exit 1
fi

ln -s .vimrc $1/.vimrc 
ln -s .vimrc_additions $1/.vimrc_additions
ln -s .zshrc $1/.zshrc

echo "-------------------------------"
echo "Config files linked"
echo "-------------------------------"

# Now, install oh-my-zsh
$config_directory = pwd
cd $1
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
cd .oh-my-zsh/plugins

echo "------------------------------"
echo "ohmyzsh installed"
echo "------------------------------"

# Pull the plugins
git pull https://github.com/zsh-users/zsh-syntax-highlighting
git pull https://github.com/zsh-users/zsh-autosuggestions


echo "------------------------------"
echo "ohmyzsh plugins installed"
echo "------------------------------"

# Now, insatll Vundle:
cd ../..
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "------------------------------"
echo "Vundle installed"
echo "------------------------------"

# Finally, install powerline:
pip install --user git+git://github.com/Lokaltog/powerline

wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/


echo "------------------------------"
echo "powerline installed"
echo "------------------------------"

echo "Done!"
