#!/bin/bash


# define here for future use
function __eg_command_exists
{
	command -v "$1" &> /dev/null
}

# ensure we don't double include env.d
EG_BASH_ENV_D=1

# Bash file history size
export HISTFILESIZE=10000

# vim: filetype=bash