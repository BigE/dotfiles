#!/bin/bash

if [ -d "$HOME/.shellrc/login.d" ]; then
	# first load all common login items
	for file in "$HOME"/.shellrc/login.d/*.sh; do
		source "$file"
	done

	# now load all bash specific login and overrides
	for file in "$HOME"/.shellrc/login.d/*.bash; do
		source "$file"
	done
fi

# Do the interactive part last to keep things similar between zsh/bash
if [ -f "$HOME/.bashrc" ]; then
	source "$HOME/.bashrc"
fi

# vim: ft=bash