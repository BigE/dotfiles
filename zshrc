#!/bin/zsh

# Uncomment this for profiling
#zmodload zsh/zprof

if [ -d "$HOME"/.shellrc/rc.d ]; then
	setopt nullglob

	# first the common rc items
	for file in "$HOME"/.shellrc/rc.d/*.sh; do
		source "$file"
	done

	# now load the zsh specific rc items
	for file in "$HOME"/.shellrc/rc.d/*.zsh; do
		source "$file"
	done

	unsetopt nullglob
fi

# Uncomment this for profiling
#zprof

#vim: filetype=zsh