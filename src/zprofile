#!/bin/zsh

if [ -d "$HOME"/.shellrc/login.d/ ]; then
	# make sure we don't error if files don't exist
	setopt nullglob

	# Load all of the common items. Control the order by using a numerical
	# prefix for naming. 00 is loaded before 01, etc.
	files=("$HOME"/.shellrc/login.d/*.{sh,zsh})
	for file in "${(n)files[@]}"; do
		source "$file"
	done

	# back to normal
	unsetopt nullglob
fi

# vim: filetype=zsh
