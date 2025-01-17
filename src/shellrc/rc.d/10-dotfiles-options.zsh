#!/bin/zsh


# let oh-my-zsh know we want to do our own thing
if [ "$EG_DISABLE_LS_COLORS" -eq 1 ]; then
	DISABLE_LS_COLORS=true
	zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
fi

# Now finalize configuration by ensuring specific variables are set

# history file
[ -z "$HISTFILE" ] && export HISTFILE="${HOME}/.zsh_history"

# history items in history file
[ -z "$SAVEHIST" ] && export SAVEHIST="10000"

###############################################################################
# OPTIONS
###############################################################################

for OPTION in "${EG_ZSH_OPTIONS[@]}"; do
	setopt "${OPTION}"
done

# vim: filetype=zsh