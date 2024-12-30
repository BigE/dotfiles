#!/bin/zsh

if [ -d "$HOME"/.shellrc/login.d/ ]; then
	# first source the common login items
	for file in "$HOME"/.shellrc/login.d/*.sh; do
		source "$file"
	done

	# now we run ZSH specifics and overrides
	for file in "$HOME"/.shellrc/login.d/*.zsh; do
		source "$file"
	done
fi

# vim: filetype=zsh
