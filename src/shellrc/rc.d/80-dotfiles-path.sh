#!/bin/sh


###############################################################################
# PATH
###############################################################################

# On MacOS we want to use the GNU programs from homebrew
if [ -n "$BREW_LOCATION" ]; then
	if [ -d "$($BREW_LOCATION --prefix coreutils)" ]; then
		PATH="$($BREW_LOCATION --prefix coreutils)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix coreutils)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU find
	if [ -d "$($BREW_LOCATION --prefix findutils)" ]; then
		PATH="$($BREW_LOCATION --prefix findutils)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix findutils)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU awk
	if [ -d "$($BREW_LOCATION --prefix gawk)" ]; then
		PATH="$($BREW_LOCATION --prefix gawk)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gawk)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU sed
	if [ -d "$($BREW_LOCATION --prefix gnu-sed)" ]; then
		PATH="$($BREW_LOCATION --prefix gnu-sed)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gnu-sed)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU tar
	if [ -d "$($BREW_LOCATION --prefix gnu-tar)" ]; then
		PATH="$($BREW_LOCATION --prefix gnu-tar)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gnu-tar)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi
fi

if [ -z "$PHPENV_ROOT" ] && [ -d "${HOME}/.phpenv" ]; then
	export PHPENV_ROOT="${HOME}/.phpenv"
fi

if [ -n "$PHPENV_ROOT" ]; then
	export PATH="${PHPENV_ROOT}/bin:${PATH}"
fi

# vendor/bin/ for composer projects - see http://getcomposer.org
# ~/.local/bin for local stuffs
export PATH="./vendor/bin:${HOME}/.composer/vendor/bin:${HOME}/.local/bin:${PATH}"

# vim: filetype=sh