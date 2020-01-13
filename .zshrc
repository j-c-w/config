# Add local public keys.
eval $(ssh-agent -s) > /dev/null

# Add local scripts to the path.
export PATH=$PATH:~/Dropbox/Processes
export PATH=$PATH:$HOME/bin:$HOME/.scripts
export PATH=$PATH:$HOME/.scripts/AcceleratorCoverageScripts/

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

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# This sets the default editor as vim
export VISUAL=vim
export EDITOR="$VISUAL"

# Make the timeout before going into vim mode 0.1ms.
# Somewhere someone online said this might have side-effects.
export KEYTIMEOUT=1

# This is for aliases, themes, environment variables, etc.
# that should only be set on a particular machine.
if [ -f ~/.zshrc_local ]; then
	source ~/.zshrc_local
fi

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
 colored-man-pages extract web-search ssh-agent)

zstyle :omz:plugins:ssh-agent agent-forwarding on

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

# Any bad color combos from servers this hits should be fixed
# here.

export PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;34m%}@%{\e[0m%}%{\x1b[38;2;${DEVICE_RED};${DEVICE_GREEN};${DEVICE_BLUE}m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[2;28m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}%!%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}${prompt_header}%{\e[0;34m%}%B]%{\e[0m%}%b '
export RPROMPT='[%*]'
export PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

eval `gnome-keyring-daemon --start`
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

# If we are starting a TMUX session, then print out the
# the TMUX name.
if [[ -n $TMUX ]]; then
	echo -n "You are in shell "
	tmux display-message -p '#S'
fi

# An array of names for TMUX to choose from.
tmux_names=( TPU FPGA CGRA KVS DCT FIR IIR FFT OuterSPACE NIC Needle )
tmux_names=( Tahoe Reno NewReno Westwood Hybla Vegas BIC CUBIC BBR Peach SACK FACK RBP Asym FAST Illinois HTCP Ledbat DCTCP Remy Sprout PRR PCC TIMELY Proprate Vivace Copa )
# Only try to start tmux if this is an interactive session.
# Also don't try to start tmux if we are already in a tmux.
if [[ $- == *i* ]] && [[ -z $TMUX ]]; then
	# Start tmux with a name.  If nothing is entered then we use the default tmux numbering.
	read 'tmux_name?Window name (<CR> for autonumber, "0<CR>" for no tmux)?'
	if [[ $tmux_name == "" ]]; then
		made=True
		failed_count=0
		while [[ $made == True ]]; do
			date=$$$(date +%N)
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
fi
unset tmux_names
