#!/bin/bash


################################################################################
# Helpers that will be used throughout this file and to generate the PS1.
################################################################################

function __eg_datetime_display
{
	[ -n "$EG_DATETIME" ] && echo -n "[$EG_DATETIME]"
}

function __eg_fg_color
{
	echo -ne "$(tput setaf $1)"
}

function __eg_function_exists
{
	declare -f -F $1 > /dev/null
	return $?
}

function __eg_loads
{
	echo -n "$(uptime | awk -F'[a-z]: ' '{printf $2}' | sed 's/,//g')"
}

function __eg_prompt_command
{
	EG_LAST_EXIT_CODE="$?"
	EG_DATETIME=$(date "+${EG_DATETIME_FORMAT}")
	EG_LAST_EXIT=""
	EG_PWD=$(pwd)
	EG_PWD="${EG_PWD/#$HOME/~/}"

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

	EG_FILL=$(printf "%${fillsize}s" '')
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

# vim: filetype=bash