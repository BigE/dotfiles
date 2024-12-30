#!/bin/zsh

if [ -d "$HOME"/.shellrc/login.d/ ]; then
	# make sure we don't error if files don't exist
	setopt nullglob

	# first source the common login items
	for file in "$HOME"/.shellrc/login.d/*.sh; do
		source "$file"
	done

	# now we run ZSH specifics and overrides
	for file in "$HOME"/.shellrc/login.d/*.zsh; do
		source "$file"
	done

	# back to normal
	unsetopt nullglob
fi

# vim: filetype=zsh
