#!/bin/bash


################################################################################
# This will import everything we need and setup the base environment and config
################################################################################

# import bash completion
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
elif __eg_command_exists brew; then
	if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
		source "$(brew --prefix)/etc/bash_completion"
	elif [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
		source "$(brew --prefix)/share/bash-completion/bash_completion"
	fi
fi

# Source the git-prompt.sh file for vcs completion
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	# because reasons ... there has to be a better way in fedora
	source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f /usr/share/git/completion/git-prompt.sh ]; then
	# this is the location for arch
	source /usr/share/git/completion/git-prompt.sh
elif [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
	# because OSX
	source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
fi

# Disable the virtual environment prompt, I prefer my own
export VIRTUAL_ENV_DISABLE_PROMPT=1

# show more git info - leaving these disabled
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=

# if you want to see svn modifications set this to 1
export SVN_SHOWDIRTYSTATE=

# Disabled by default, enable this to show the date in the prompt
#export EG_DATETIME_FORMAT="%Y-%m-%d %H:%M:%S"

# vim: filetype=bash