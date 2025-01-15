#!/bin/sh

# Set generic environment variables here

# language
[ -z "$LC_ALL" ] && export LC_ALL="$LANG"

# EDITOR
if [ -z "$EDITOR" ] && command -v vim > /dev/null; then
	EDITOR="$(which vim)"
	export EDITOR
fi

# default history memory size
[ -z "$HISTSIZE" ] && export HISTSIZE=10000

# pyenv
[ -z "$PYENV_ROOT" ] && export PYENV_ROOT="${HOME}/.pyenv"

# virtualenv
[ -z "$PROJECT_HOME" ] && export PROJECT_HOME="${HOME}/Projects"
[ -z "$PROJECT_HOME" ] && export WORKON_HOME="${HOME}/.virtualenv"

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

# vim: filetype=sh