# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# My custom zshrc using zgen

#zmodload zsh/zprof

zsh_wifi_signal(){
	local signal=""
	if which nmcli &> /dev/null; then
		signal=$(nmcli device wifi | grep yes | awk '{print $8}')
	elif [[ $OSTYPE = (darwin)* ]]; then
		signal=$(echo "2*($(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | awk '{print $2}') + 100)" | bc)
	fi

	if [[ ! -z "$signal" ]]; then
		local color='%F{yellow}'
		[[ $signal -gt 75 ]] && color='%F{green}'
		[[ $signal -lt 50 ]] && color='%F{red}'
		echo -n "%{$color%}$signal%% \uf1eb%{%f%} " # \uf230 is 
	fi
}

# Generic settings
#POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="black"
#POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"

#POWERLEVEL9K_MODE="nerdfont-complete"

#POWERLEVEL9K_PROMPT_ON_NEWLINE=true
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator os_icon context dir dir_writable vcs pyenv rbenv virtualenv)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time_joined background_jobs load ram battery ssh)

#POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
#POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"
#POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\u256D""\u2500"
#POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570""\uF460 "
#POWERLEVEL9K_TIME_FORMAT="%D{\uF017 %T}"

ZSH_TMUX_ITERM2=false
if [ ! -z $ITERM_SESSION_ID ]; then
	# I iterm2 - disables loading of ~/.tmux.conf - https://github.com/robbyrussell/oh-my-zsh/pull/1903
	ZSH_TMUX_ITERM2=true
fi

# Config for zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]='bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

###############################################################################
# OPTIONS
###############################################################################

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones. 

# Include the common things before we load it all up
[ -f ~/.commonrc ] && source ~/.commonrc

if [ -z "$HISTFILE" ]; then
	export HISTFILE="$HOME/.zsh_history"
fi

if [ -z "$SAVEHIST" ]; then
	export SAVEHIST=10000
fi

#disable oh-my-zsh from making aliases, I do what I want
DISABLE_LS_COLORS=true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# make sure our path is unique
export -U PATH="$PATH"

###############################################################################
# PLUGINS
###############################################################################

# Install zgen and plugins
[ -d ~/.zgen ] || git clone https://github.com/tarjoilija/zgen.git ~/.zgen
source ~/.zgen/zgen.zsh

# if the init script doesn't exist
if ! zgen saved; then

	# init oh-my-zsh core
	zgen oh-my-zsh
	# pull in plugins from oh-my-zsh
	zgen oh-my-zsh plugins/command-not-found
	zgen oh-my-zsh plugins/docker
	zgen oh-my-zsh plugins/docker-compose
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/git-flow-avh
	zgen oh-my-zsh plugins/pip
	zgen oh-my-zsh plugins/sudo
	zgen oh-my-zsh plugins/virtualenvwrapper
	zgen oh-my-zsh plugins/vscode
	zgen oh-my-zsh plugins/yarn

	if [[ $OSTYPE = (linux)* ]]; then
		if type pacman > /dev/null; then
			zgen oh-my-zsh plugins/archlinux
		fi

		if type dnf > /dev/null; then
			zgen oh-my-zsh plugins/dnf
		fi

		if type apt > /dev/null; then
			zgen oh-my-zsh plugins/debian;
		fi
	fi

	if [[ $OSTYPE = (darwin)* ]]; then
		zgen oh-my-zsh plugins/macos

		if type brew > /dev/null; then
			zgen oh-my-zsh plugins/brew
		fi

		if type port > /dev/null; then
			zgen oh-my-zsh plugins/macports
		fi
	fi

	zgen oh-my-zsh plugins/pyenv
	zgen oh-my-zsh plugins/nvm
	zgen oh-my-zsh plugins/rvm

	# theme it up bitches
	zgen load romkatv/powerlevel10k powerlevel10k

	# other plugins
	zgen load zsh-users/zsh-completions src
	zgen load zsh-users/zsh-syntax-highlighting

	# system packages
	if [ -d /usr/share/zsh/site-functions ]; then
		zgen load /usr/share/zsh/site-functions
	fi
	
	# local system packages
	if [ -d /usr/local/share/zsh/site-functions ]; then
		zgen load /usr/local/share/zsh/site-functions
	fi

	# speedup startup
	zgen save
fi

###############################################################################
# STARTUP
###############################################################################

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#zprof

# We done.
# vim: ft=zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
