#!/bin/sh


###############################################################################
# INITALIZATION
###############################################################################

# Setup phpenv if it exists
if [ -n "$PHPENV_ROOT" ]; then
	eval "$("${PHPENV_ROOT}"/bin/phpenv init -)"
fi

# start the powerline daemon, if available
if command -v powerline-daemon > /dev/null; then
	POWERLINE_CONFIG_COMMAND="$(command -v powerline-config)"
	export POWERLINE_CONFIG_COMMAND
	powerline-daemon -q
fi

# vim: filetype=sh