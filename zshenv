#!/bin/zsh

if [ -d "$HOME/.shellrc/env.d" ]; then
	# disable glob errors in case files don't exist
	setopt nullglob

	# first source the common env files
	for file in "$HOME"/.shellrc/env.d/*.sh; do
		source "$file"
	done

	# second source the zsh specific ones
	for file in "$HOME"/.shellrc/env.d/*.zsh; do
		source "$file"
	done

	# back to normal
	unsetopt nullglob
fi

# make sure our path is unique
export -U PATH="$PATH"

#vim: filetype=zsh