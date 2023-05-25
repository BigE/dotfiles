# This is a bashrc, if we're not interactive, gtfo!
if [[ $- != *i* ]]; then
	return
fi

################################################################################
# Helpers that will be used throughout this file and to generate the PS1.
################################################################################

# This is output before the top prompt
EG_TITLEBAR=""

EG_PROMPT_SYMBOL="%"

function __eg_command_exists
{
	command -v "$1" &> /dev/null
}

function __eg_datetime_display
{
	if [ ! -z "$EG_DATETIME" ]; then
		echo -n "[$EG_DATETIME]"
	fi
}

function __eg_fg_color
{
	echo -ne $(tput setaf $1)
}

function __eg_function_exists
{
	declare -f -F $1 > /dev/null
	return $?
}

function __eg_loads
{
	echo -n $(uptime | awk -F'[a-z]:' '{ printf $2}' | sed 's/,//g')
}

function __eg_prompt_command
{
	EG_LAST_EXIT_CODE="$?"
	EG_DATETIME=$(date "+${EG_DATETIME_FORMAT}")
	EG_LAST_EXIT=""
	EG_PWD=$(pwd)
	EG_PWD="${EG_PWD/#$HOME/\~}"

	case $TERM in
		xterm*|rxvt*|Eterm)
			echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"
		;;
		screen)
			echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"
		;;
	esac

	local ps1="$EG_TITLEBAR${USER}@${HOSTNAME} [${EG_PWD}]$(__eg_vcs_ps1_display)$(__eg_virtualenv_ps1_display)$(__eg_datetime_display)[$(__eg_loads)]"

	if [ "$EG_LAST_EXIT_CODE" -ne 0 ]; then
		EG_LAST_EXIT=" ($EG_LAST_EXIT_CODE)"
		ps1+="${EG_LAST_EXIT}"
	fi

	let fillsize=$(tput cols)-${#ps1}

	if [ "$fillsize" -lt 0 ]; then
		# here's how we choose what to cut
		if [ ! -z "${EG_DATETIME}" ]; then
			local datetime_display="$(__eg_datetime_display)"
			fillsize=${fillsize}+${#datetime_display}
			EG_DATETIME=""
		fi

		if [ "$fillsize" -lt 0 ]; then
			let cut=3-${fillsize}
			EG_PWD="...${EG_PWD:${cut}}"
			fillsize=0
		fi
	fi

	local fill="                                                                                                                                                                                                                                                                                                                                                                                                                                  "
	EG_FILL="${fill:0:${fillsize}}"
}

function __eg_svn_ps1
{
	if __eg_command_exists svn; then
		WD=$( while ! test -d ".svn" && [[ `pwd` != "/" ]]; do cd ..; done; pwd )
		# This assumes we don't have a svn repo at the root folder
		if [ "$WD" != "/" ]; then
			# grab the info and pass it into the available functions
			local info=$(svn info 2>/dev/null)

			if [ ! -z "$info" ]; then
				local b=$(__eg_vcs_svn_branch "$info")
				local r=$(__eg_vcs_svn_revision "$info")

				if [ ! -z "$b" ]; then
					r="$b:$r"
				fi

				echo -n "$r"
			fi
		fi
	fi
}

function __eg_vcs_svn_revision()
{
	local r=`echo "$*" | awk '/Revision:/ {print $2}'`

	if [ $? -eq 0 ] && [ ! -z "$r" ]; then
		if [ ! -z "$SVN_SHOWDIRTYSTATE" ] && [ "$SVN_SHOWDIRTYSTATE" -ne "0" ]; then
			local svnst flag
			svnst=$(svn status | grep '^\s*[?ACDMR?!]')
			[ -z "$svnst" ] || r="$r *"
		fi

		echo -n "$r"
	fi
}

function __eg_vcs_svn_branch()
{
	local url=`echo -e "$*" | awk '/^URL:/ {print $2}'`

	if [[ $url =~ trunk ]]; then
		echo trunk
	elif [[ $url =~ /branches/ ]]; then
		echo $url | sed -e 's#^.*/\(branches/.*\)\(/.*\)\?$#\1#'
	elif [[ $url =~ /tags/ ]]; then
		echo $url | sed -e 's#^.*/\(tags/.*\)\(/.*\)\?$#\1#'
	fi
}

function __eg_vcs_ps1_display
{
	if [ -n "$(__eg_vcs_ps1)" ]; then
		echo -n " ($(__eg_vcs_ps1_type):$(__eg_vcs_ps1))"
	fi
}

function __eg_vcs_ps1_type
{
	if [ -n "$(__eg_svn_ps1)" ]; then
		echo -n 'svn'
	elif __eg_function_exists __git_ps1 && [ -n "$(__git_ps1)" ]; then
		echo -n 'git'
	fi
}

function __eg_vcs_ps1
{
	local vcs=

	if [ -n "$(__eg_svn_ps1)" ]; then
		vcs="$(__eg_svn_ps1)"
	elif __eg_function_exists __git_ps1; then
		vcs=`__git_ps1 "%s"`
	fi

	echo -n "$vcs"
}

function __eg_virtualenv_ps1_display
{
	if [ ! -z "$(__eg_virtualenv_ps1)" ]; then
		echo -n " [env:$(__eg_virtualenv_ps1)]"
	fi
}

function __eg_virtualenv_ps1
{
	if [ -n "$VIRTUAL_ENV" ]; then
		echo -n "${VIRTUAL_ENV##*/}"
	fi
}

################################################################################
# This will import everything we need and setup the base environment and config
################################################################################
if [ -f /etc/profile ]; then
	source /etc/profile
fi

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

# Generic setup for environment
if [ -f $HOME/.commonrc ]; then
	source $HOME/.commonrc
fi

# exports for environment

# Disable the virtual environment prompt, I prefer my own
export VIRTUAL_ENV_DISABLE_PROMPT=1

# if not already set, virtualenvs should reside here
if [ -z "$WORKON_HOME" ]; then
	export WORKON_HOME=$HOME/.virtualenvs
fi

# This is where I like to keep my projects
if [ -z "$PROJECT_HOME" ]; then
	export PROJECT_HOME=$HOME/Projects
fi

# My editor
if __eg_command_exists vim
then
	export EDITOR="vim"
	export DIETY=$EDITOR # haha
elif __eg_command_exists nano
then
	export EDITOR="nano" # not diety
fi

#Enable colors for ls, etc. Prefer ~/.dir_colors #64489
if __eg_command_exists dircolors; then
	if [[ -f ~/.dir_colors ]]; then
		# local directory colors
		eval `dircolors -b ~/.dir_colors`
	elif [[ -f /etc/DIR_COLORS ]]; then
		# This is for Gentoo/RedHat systems
		eval `dircolors -b /etc/DIR_COLORS`
	else
		# Added this in for Debian/Ubuntu systems
		eval `dircolors`
	fi
fi

# show more git info - leaving these disabled, enable them in .bashrc_local
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=

# if you want to see svn modifications set this to 1
export SVN_SHOWDIRTYSTATE=

# Disabled by default, enable this to show the date in the prompt
#export EG_DATETIME_FORMAT="%Y-%m-%d %H:%M:%S"

################################################################################
# alias setup - these linux specific, feel free to override in .bashrc_local
################################################################################

if [[ $OSTYPE == "darwin"* ]]; then
	alias ls="ls -hG"
else
	alias ls="ls -h --color=auto"
fi

alias grep="grep --color"
alias ll="ls -l"
alias la="ls -a"
alias rm="rm -i" # use -i by default to make sure we want to delete it

################################################################################
# I almost felt like these were clutter... almost.
################################################################################
RESET=$(tput sgr0)
BOLD=$(tput bold)
BLACK=$(__eg_fg_color 0)
RED=$(__eg_fg_color 1)
GREEN=$(__eg_fg_color 2)
YELLOW=$(__eg_fg_color 3)
BLUE=$(__eg_fg_color 4)
PURPLE=$(__eg_fg_color 5)
TEAL=$(__eg_fg_color 6)
WHITE=$(__eg_fg_color 7)

################################################################################
# Import local settings to override things before we generate the PS1
################################################################################

if [ -f $HOME/.bashrc_local ]; then
	source $HOME/.bashrc_local
fi

# Setup the virtualenv wrapper if it exists
if [[ -f ~/.local/bin/virtualenvwrapper.sh ]]; then
	source ~/.local/bin/virtualenvwrapper.sh
elif [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
elif [[ -f /bin/virtualenvwrapper.sh ]]; then
	source /bin/virtualenvwrapper.sh
elif [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi

################################################################################
# PS1 - override this in ~/.bashrc_ps1, I will import it before exporting PS1
################################################################################

PS1="${EG_TITLEBAR}\[$BOLD$GREEN\]${USER}\[$BLUE\]@\[$GREEN\]${HOSTNAME}\[$RESET\]"
PS1+="\[$BOLD$RED\]\$EG_LAST_EXIT\[$RESET\]"
PS1+=" \[$BOLD$BLUE\][\[$(__eg_fg_color 102)\]\$EG_PWD\[$BLUE\]]\[$RESET\]"
PS1+='$([[ -z "$(__eg_vcs_ps1)" ]] || echo -n \[$BOLD$BLUE\] \(\[$TEAL\]$(__eg_vcs_ps1_type):\[$RED\]$(__eg_vcs_ps1)\[$BLUE\]\)\[$RESET\])'
PS1+='$([[ -z "$(__eg_virtualenv_ps1)" ]] || echo -n \[$BOLD$BLUE\] [\[$TEAL\]env:\[$PURPLE\]$(__eg_virtualenv_ps1)\[$BLUE\]]\[$RESET\])'
PS1+="\$EG_FILL"
PS1+='$([[ -z $EG_DATETIME ]] || echo -n \[$BOLD$BLUE\][\[$TEAL\]$EG_DATETIME\[$BLUE\]]\[$RESET\])'
PS1+="\[$BOLD$BLUE\][\[$(__eg_fg_color 202)\]\$(__eg_loads)\[$BLUE\]]\[$RESET\]"
PS1+="\n"
PS1+='$([[ $EG_LAST_EXIT_CODE -eq 0 ]] || echo -n \[$RED\])' # simply turns the prompt red when last exit was not 0
PS1+="\${EG_PROMPT_SYMBOL}\[$(tput sgr0)\] "

################################################################################
# PROMPT_COMMAND - override this in ~/.bashrc_ps1 also
################################################################################
export PROMPT_COMMAND=__eg_prompt_command

# If it exists, import it, allowing changes to the prompt
if [ -f "$HOME/.bashrc_ps1" ]; then
	source "$HOME/.bashrc_ps1"
fi

export PS1
