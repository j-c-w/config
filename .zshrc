# Add local public keys. -- Do not do for eddie
# eval $(ssh-agent -s) > /dev/null
use_tmux=yes
# Zsh error message told me to do this because the eddie
# permissions aren't right.
ZSH_DISABLE_COMPFIX=true

# Add local scripts to the path.
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:~/Dropbox/Processes
export PATH=$PATH:$HOME/bin:$HOME/.scripts
export PATH=$PATH:$HOME/.scripts/AcceleratorCoverageScripts/
export PATH=$PATH:$HOME/.scripts/Functions
export PATH=$PATH:$HOME/.local/bin
export OPENAI_API_KEY=$(cat ~/.open_ai_api)
export PATH=$PATH:/Users/jwoodruf/.local/bin

# For the cr and vr commands, which cd and open files
# in vim from the folders in this path.
# if files don't exist, it's not important.
fzf_files_path=( ~/Dropbox ~/Projects ~/LocalProjects ~/mnt_ubuntu/Projects )
FZF_FILES_PATH=${(j<:>)fzf_files_path}
FZF_SYMLINK_DIR=~/.fzf_files_path_links

# Takes the fzf_files_path variable and creates symlinks
# to everything that exists.
function update_fzf_symlinks_directory() {
	local file
	local symlink_name
	mkdir -p $FZF_SYMLINK_DIR
	for file in ${fzf_files_path[@]}; do
		symlink_name=$FZF_SYMLINK_DIR/${file:gs/\//_}
		if [[ -e $file ]] && [[ ! -e $symlink_name ]]; then
			ln -s $file $symlink_name
		fi
	done
}
update_fzf_symlinks_directory

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Make it clear that nested TMUXes support 256 colors
export TERM=xterm-256color

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="duellj"

if [ -d "/usr/local/systemc-2.3/" ]; then
	export SYSTEMC_HOME="/usr/local/systemc-2.3/"
	export LD_LIBRARY_PATH="/usr/local/systemc-2.3/lib-linux64:$LD_LIBRARY_PATH"
fi

if [[ -n "${commands[fzf-share]}" ]]; then
	source "$(fzf-share)/key-bindings.zsh"
	source "$(fzf-share)/completion.zsh"
fi

# For the prompt, an optional extension used for compute cluster nodes right now.
NODE_TYPE=""
HOSTNAME=$(hostname)

# Load specific zshrcs for each machine
# Load the eddie zshrc if required:
if [[ $HOSTNAME == *.ecdf.ed.ac.uk ]]; then
	echo "Using an EDDIE machine"
	source ~/.scripts/EddieScripts/.eddie_zshrc
fi

if [[ $HOSTNAME == jacksons-laptop ]]; then
	echo "Using your LAPTOP"
	source ~/.scripts/LaptopScripts/.laptop_zshrc
fi

# This is for aliases, themes, environment variables, etc.
# that should only be set on a particular machine.
if [ -f ~/.zshrc_local ]; then
	# $HOSTNAME == ... should be prefered.
	source ~/.zshrc_local
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# This sets the default editor as vim
export VISUAL=vim
export EDITOR="$VISUAL"

# Make the timeout before going into vim mode 0.1ms.
# Somewhere someone online said this might have side-effects.
export KEYTIMEOUT=1

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting history z zsh-autosuggestions
 colored-man-pages extract web-search nix-shell nix-zsh-completions nix-zsh-completions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Changes the prompt to be a little less wordy

# Some options
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set vi to be the default editor here
bindkey -v
# Keep ^R as back-i search.
bindkey "^R" history-incremental-search-backward

# Enables the (v|c)Xpd commands which search from the
# same directory as the last successful v or c command.
PREVIOUS_JUMP_DIRECTORY=~

function c() {
	local dir
	dir=$(c.sh $@)
	if [[ ! -z $dir && -d $dir ]]; then
		cd $dir
	fi
}

function ch() {
	cd ~/$(cd ~; c.sh $@)
}

function cs() {
	cd /$(cd /; c.sh $@)
}

function cl() {
	cd $(c_locate.sh $@)
}

function cpd() {
	cd $(cd $PREVIOUS_JUMP_DIRECTORY; c.sh $@)
}

# c restricted, uses the FZF_FILES_PATH variable.
function cr() {
	update_fzf_symlinks_directory
	cd ~/$(cd $FZF_SYMLINK_DIR; c.sh $@)
}

function cd_and_open_in_vim() {
	local file="$1"
	if [[ -f "$file" ]]; then
		PREVIOUS_JUMP_DIRECTORY=$PWD
		cd $(dirname "$file")
		echo "Opening $(basename $file)"
		vim $(basename "$file")
	else
		echo "File $file not found, not opening"
		return 0
	fi
}

function open_vim_from_line_match() {
	local line="$1"
	if [[ $line == '' ]]; then
		echo "Line empty; not opening"
		return 0
	fi
	local filename

	filename="$(cut -d':' -f1 <<< "$line")"
	PREVIOUS_JUMP_DIRECTORY=$PWD
	cd "$(dirname $filename)"
	lineno="$(cut -d':' -f2 <<< "$line")"
	echo "Opening $(basename $filename)"
	vim "$(basename $filename)" +$lineno
}

# Open vim from the filenames accessible from where
# the pointer currently is.
function v() {
	local file
	file=$(f $@)
	cd_and_open_in_vim "$file"
}

# Open vim restricted, uses the FZF_SYMLINK_DIR variable
function vr() {
	local file
	update_fzf_symlinks_directory
	file=$(f --dir $FZF_SYMLINK_DIR $@)
	cd_and_open_in_vim "$file"
}

# Open vim from the system-wide filenames.
function vs() {
	local file
	file=$(fs $@)
	cd_and_open_in_vim "$file"
}

# Open vim from the home directory file names.
function vh() {
	local file
	file="$(fh $@)"
	cd_and_open_in_vim "$file"
}

# Open vim based on file names in the locate-DB
function vl() {
	local file
	file="$(fl $@)"
	cd_and_open_in_vim "$file"
}

# Go up within the project; here specified by a git repo, but
# a better check is possible.
function vg() {
	local initial_dir="$PWD"
	while [[ "$PWD" != / ]] && [[ ! -e .git ]]; do
		cd ..
	done
	if [[ $PWD == / ]]; then
		echo "No project found"
		cd $initial_dir
	else
		v "$@"
	fi
}

# Do a v-command in the previous directory where cX or vX was  used.
function vpd() {
	echo $PREVIOUS_JUMP_DIRECTORY
	file="$(f --dir $PREVIOUS_JUMP_DIRECTORY $@)"
	# Pretend we were in the previous jump directory if
	# we do the next step, so that the old jump directory
	# isn't updated.
	if [[ -f $file ]]; then
		cd $PREVIOUS_JUMP_DIRECTORY
	fi
	cd_and_open_in_vim "$file"
}

# Open vim based on file contents.
function vc() {
	line="$(file_search $@)"
	open_vim_from_line_match "$line"
}

# Open vim based on file contents recursively.
function vcr() {
	line="$(file_search -r $@)"
	open_vim_from_line_match "$line"
}

# These keep track of new lines and key presses.  They update
# the prompt depending on whether we are in vi mode or not.
prompt_header="$"
function zle-line-init zle-keymap-select() {
	if [[ $KEYMAP == *vicmd* ]]; then
		# In VI mode:
		prompt_header="V"
	else
		prompt_header="$"
	fi
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Just set the theme to duelj manually.  The colors' don't work well with a plain background, so fix that.
# Get the hostname and hash it to a color.
DEVICE_COLOR=$(( $(( 0x$(sha1sum <<< "$(whoami)$(hostname)" | cut -c1-10) )) % (256 * 256 * 256) ))

DEVICE_RED=$(( $DEVICE_COLOR % 256 ))
DEVICE_GREEN=$(( ($DEVICE_COLOR / 256) % 256 ))
DEVICE_BLUE=$(( ($DEVICE_COLOR / (256 * 256)) % 256 ))
VISIBLE_USER="$(whoami)"
# USERCOLOR=

if [[ ! -z $IN_NIX_SHELL ]]; then
	if [[ -z $SHELL_NAME ]]; then
		VISIBLE_USER="nix-shell"
	else
		VISIBLE_USER="$SHELL_NAME"
	fi
fi

# Any bad color combos from servers this hits should be fixed
# here.
export PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}${VISIBLE_USER}%{\e[1;34m%}@%{\e[0m%}%{\x1b[38;2;${DEVICE_RED};${DEVICE_GREEN};${DEVICE_BLUE}m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - ${NODE_TYPE}%b%{\e[0;34m%}%B[%b%{\e[2;28m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}${prompt_header}%{\e[0;34m%}%B]%{\e[0m%}%b '
export RPROMPT='[%*]'
export PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
setopt promptsubst

rename() {
	local new_name=$1
	tmux rename-session $new_name
}

view() {
	local name=$1
	tmux switch-client -t $name
}

is_session() {
	local tmux_name=$1
	matched=False
	current_sessions=($(tmux list-sessions -F '#{session_name}'))
	for session in $current_sessions; do
		if [[ $session == $tmux_name ]]; then
			matched=True
			break
		fi
	done

	echo $matched
}

if [ -e /home/jackson/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jackson/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# If we are starting a TMUX session, then print out the
# the TMUX name.
if [[ -n $TMUX ]]; then
	echo -n "You are in shell "
	tmux display-message -p '#S'
fi

function tmux-new() {
	# An array of names for TMUX to choose from.
	tmux_names=( TPU FPGA CGRA KVS DCT FIR IIR FFT OuterSPACE NIC Needle )
	tmux_names=( Tahoe Reno NewReno Westwood Hybla Vegas BIC CUBIC BBR Peach SACK FACK RBP Asym FAST Illinois HTCP Ledbat DCTCP Remy Sprout PRR PCC TIMELY Proprate Vivace Copa )

	# Start tmux with a name.  If nothing is entered then we use the default tmux numbering.
	echo "Existing TMUX sessions are: "
	tmux list-sessions -F '#{session_name}: #T (#{session_attached})'
	read 'tmux_name?Window name (<CR> for autonumber, "0<CR>" for no tmux)?'
	if [[ $tmux_name == "" ]]; then
		made=True
		failed_count=0
		while [[ $made == True ]]; do
			date=$$$(date +%N)
			echo ${#tmux_names[@]}
			echo $date
			index=$(( date % ${#tmux_names[@]} + 1 ))
			name=${tmux_names[$index]}
			made=$(is_session $name)
			if [[ $name == "" ]]; then
				echo "Failed to get a name from the list! Debug information is below:"
				echo $index
				echo $name
				echo ${#tmux_name[@]}
			fi
			if [[ $made == False  ]]; then
				tmux new-session -s $name
			fi

			failed_count=$(( failed_count + 1 ))
			if [[ $failed_count -gt 100 ]]; then
				echo "Couldn't find a name for the new terminal"
			fi
		done
		unset name
		unset index
		unset failed_count
		unset made
	elif [[ $tmux_name != "0" ]]; then
		matched=$(is_session $tmux_name)

		if [[ $matched == False ]]; then
			echo "No tmux session found, making a new session ($tmux_name)!"
			tmux new-session -s $tmux_name
		else
			echo "Existing tmux session ($tmux_name) found.  Attaching..."
			tmux attach-session -t $tmux_name
		fi
		unset matched
	else
		echo "No tmux session started"
	fi
}

# Only try to start tmux if this is an interactive session.
# Also don't try to start tmux if we are already in a tmux.
if [[ $use_tmux == yes ]] && [[ $- == *i* ]] && [[ -z $TMUX ]]; then
	tmux-new
fi
if [ -e /home/s1988171/.nix-profile/etc/profile.d/nix.sh ]; then . /home/s1988171/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
