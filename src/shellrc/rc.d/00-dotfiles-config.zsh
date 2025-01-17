#!/bin/zsh


# My custom zshrc using zgen

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###############################################################################
# CONFIGURATION
###############################################################################

# control ls colors from oh-my-zsh
[ -z "$EG_DISABLE_LS_COLORS" ] && EG_DISABLE_LS_COLORS=1

# enable vi mode
[ -z "$EG_VI_MODE" ] && EG_VI_MODE=1

# enable oh-my-zsh
[ -z "$EG_OH_MY_ZSH" ] && EG_OH_MY_ZSH=1

# oh-my-zsh plugins to load, small default set then autodetect
if [ -z "$EG_OH_MY_ZSH_PLUGINS" ]; then
	EG_OH_MY_ZSH_PLUGINS=(
		'command-not-found'
	)

	if command -v git > /dev/null; then
		EG_OH_MY_ZSH_PLUGINS+=('git')
	fi

	if command -v sudo > /dev/null; then
		EG_OH_MY_ZSH_PLUGINS+=('sudo')
	fi
fi

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

# define default options to set
[ -z "$EG_ZSH_OPTIONS" ] && EG_ZSH_OPTIONS=(
	autocd                   # Allow changing directories without `cd`
	append_history           # Dont overwrite history
	extended_history         # Also record time and duration of commands.
	share_history            # Share history between multiple shells
	hist_expire_dups_first   # Clear duplicates when trimming internal hist.
	hist_find_no_dups        # Dont display duplicates during searches.
	hist_ignore_dups         # Ignore consecutive duplicates.
	hist_ignore_all_dups     # Remember only one unique copy of the command.
	hist_reduce_blanks       # Remove superfluous blanks.
	hist_save_no_dups        # Omit older commands in favor of newer ones.
)
