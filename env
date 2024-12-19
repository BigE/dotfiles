#!/bin/sh

# Set generic environment variables here

# language
[ -z "$LC_ALL" ] && export LC_ALL="$LANG"

# EDITOR
if command -v vim > /dev/null; then
	EDITOR="$(which vim)"
	export EDITOR
fi

# default history memory size
export HISTSIZE=10000

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"

# virtualenv
export PROJECT_HOME="${HOME}/Projects"
export WORKON_HOME="${HOME}/.virtualenv"

# homebrew
if [ -n "$OSTYPE" ] && expr "$OSTYPE" : 'darwin' > /dev/null; then
	if command -v arch > /dev/null && [ "$(arch)" = "arm64" ] && [ -f /opt/homebrew/bin/brew ]; then
		export BREW_LOCATION="/opt/homebrew/bin/brew"
	elif command -v arch > /dev/null && [ "$(arch)" = "i386" ] && [ -d /usr/local/bin/brew ]; then
		export BREW_LOCATION="/usr/local/bin/brew"
	elif ! command -v arch > /dev/null && [ -d /usr/local/bin/brew ]; then
		export BREW_LOCATION="/usr/local/bin/brew"
	fi
fi

# Finally, allow everything here to be overridden
[ -f "${HOME}/.env.local" ] && . "${HOME}/.env.local"

# vim: filetype=sh