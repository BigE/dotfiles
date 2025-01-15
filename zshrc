#!/bin/zsh

# Uncomment this for profiling
#zmodload zsh/zprof

if [ -d "$HOME"/.shellrc/rc.d ]; then
	setopt nullglob

	# Loop through all files and import them. Control the order by naming the
	# files with a ##- prefix. 00 is loaded before 01, etc.
	files=("$HOME"/.shellrc/rc.d/*.{sh,zsh})
	for file in "${(n)files[@]}"; do
		source "$file"
	done

	unsetopt nullglob
fi

# Uncomment this for profiling
#zprof

#vim: filetype=zsh