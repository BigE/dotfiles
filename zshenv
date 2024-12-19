#!/bin/zsh

# zshenv for environment variables

# set a default of 10000 lines in our history file
export SAVEHIST=10000

# this is zsh specific, so load the common env
[ -f "$HOME/.env" ] && source "$HOME/.env"

# ensure our path is unique
export -U PATH="$PATH"

# vim: filetype=zsh