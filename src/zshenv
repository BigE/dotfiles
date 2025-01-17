#!/bin/zsh

if [ -d "$HOME/.shellrc/env.d" ]; then
	# disable glob errors in case files don't exist
	setopt nullglob

	files=("$HOME"/.shellrc/env.d/*.{sh,zsh})
	for file in "${(n)files[@]}"; do
		source "$file"
	done

	# back to normal
	unsetopt nullglob
fi

# make sure our path is unique
export -U PATH="$PATH"

#vim: filetype=zsh