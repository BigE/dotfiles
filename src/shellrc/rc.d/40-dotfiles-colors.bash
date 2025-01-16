#!/bin/bash


#Enable colors for ls, etc. Prefer ~/.dir_colors #64489
if __eg_command_exists dircolors; then
	if [[ -f ~/.dir_colors ]]; then
		# local directory colors
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]]; then
		# This is for Gentoo/RedHat systems
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		# Added this in for Debian/Ubuntu systems
		eval "$(dircolors)"
	fi
fi

################################################################################
# I almost felt like these were clutter... almost.
################################################################################
RESET=$(tput sgr0)
BOLD=$(tput bold)
BLACK=$(__eg_fg_color 0)
RED=$(__eg_fg_color 1)
GREEN=$(__eg_fg_color 2)
YELLOW=$(__eg_fg_color 3)
BLUE=$(__eg_fg_color 4)
PURPLE=$(__eg_fg_color 5)
TEAL=$(__eg_fg_color 6)
WHITE=$(__eg_fg_color 7)

# vim: filetype=bash