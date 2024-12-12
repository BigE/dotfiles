#!/bin/zsh

# My custom zshrc using zgen

# Uncomment this for profiling
#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# I iterm2 - disables loading of ~/.tmux.conf - https://github.com/robbyrussell/oh-my-zsh/pull/1903
ZSH_TMUX_ITERM2=false
if [ -n "$ITERM_SESSION_ID" ]; then
	ZSH_TMUX_ITERM2=true
fi

###############################################################################
# CONFIGURATION
###############################################################################

# enable vi mode
[ -z "$EG_VI_MODE" ] && EG_VI_MODE=1

# enable oh-my-zsh
[ -z "$EG_OH_MY_ZSH" ] && EG_OH_MY_ZSH=1

# oh-my-zsh plugins to load, small default set
[ -z "$EG_OH_MY_ZSH_PLUGINS" ] && EG_OH_MY_ZSH_PLUGINS=(
	command-not-found
	git
	git-flow-avh
	sudo
)

# other zsh pluigns
[ -z "$EG_ZSH_PLUGINS" ] && EG_ZSH_PLUGINS=(
	"zsh-users/zsh-completions src"
	zsh-users/zsh-syntax-highlighting
)

# enable os detection and load package manager plugins
[ -z "$EG_OH_MY_ZSH_OS_DETECT" ] && EG_OH_MY_ZSH_OS_DETECT=1

# zsh theme
[ -z "${EG_ZSH_THEME}" ] && EG_ZSH_THEME="romkatv/powerlevel10k powerlevel10k"

# Pattern highlighting
[ -z "${ZSH_HIGHLIGHT_HIGHLIGHTERS}" ] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Highlight styles
if [ -z "${ZSH_HIGHLIGHT_STYLES}" ]; then
	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[cursor]='bold'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'
fi

# let oh-my-zsh know we want to do our own thing
DISABLE_LS_COLORS=true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

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

# Load the .commonrc file, which will load the .localrc file
[ -f "$HOME/.commonrc" ] && source "$HOME/.commonrc"

# Now finalize configuration by ensuring specific variables are set

# history file
[ -z "$HISTFILE" ] && export HISTFILE="${HOME}/.zsh_history"

# history items in history file
[ -z "$SAVEHIST" ] && export SAVEHIST="10000"

###############################################################################
# INITALIZATION
###############################################################################

# load zgen
[ -d "${HOME}/.zgen" ] || git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

	if [ -n "$EG_OH_MY_ZSH" ] && [ $EG_OH_MY_ZSH = 1 ]; then
		# first load oh-my-zsh
		zgen oh-my-zsh

		# now all the plugins
		for PLUGIN in "${EG_OH_MY_ZSH_PLUGINS[@]}"; do
			zgen oh-my-zsh "plugins/${PLUGIN}"
		done

		if [ -n "$EG_OH_MY_ZSH_OS_DETECT" ] && [ $EG_OH_MY_ZSH_OS_DETECT = 1 ]; then
			case "$OSTYPE"; in
				linux*)
					if type pacman > /dev/null; then
						zgen oh-my-zsh plugins/archlinux
					fi
				;;
				darwin*)
					zgen oh-my-zsh plugins/macos

					if type brew > /dev/null; then
						zgen oh-my-zsh plugins/brew
					fi

					if type port > /dev/null; then
						zgen oh-my-zsh plugins/macports
					fi
				;;
			esac
		fi
	fi

	# Load the theme
	zgen load $(echo "$EG_ZSH_THEME")

	# other plugins
	for PLUGIN in "${EG_ZSH_PLUGINS[@]}"; do
		zgen load $(echo "$PLUGIN")
	done

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

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

# vi mode
if [[ "$EG_VI_MODE" -eq 1 ]]; then
	bindkey -v
	bindkey "^R" history-incremental-search-backward
fi

# Theme settings (powerlevel10k) are now in the p10k.zsh file
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f "${HOME}/.p10k.zsh" ] && source "${HOME}/.p10k.zsh"

# Uncomment this for profiling
#zprof

# We done.
# vim: filetype=zsh