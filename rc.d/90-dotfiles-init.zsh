###############################################################################
# INITALIZATION
###############################################################################

# load zgen
[ -d "${HOME}/.zgen" ] || git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

	if [ -n "$EG_OH_MY_ZSH" ] && [ $EG_OH_MY_ZSH = 1 ]; then
		# first load oh-my-zsh
		zgen oh-my-zsh

		# now all the plugins
		for PLUGIN in "${EG_OH_MY_ZSH_PLUGINS[@]}"; do
			zgen oh-my-zsh "plugins/${PLUGIN}"
		done

		if [ -n "$EG_OH_MY_ZSH_OS_DETECT" ] && [ $EG_OH_MY_ZSH_OS_DETECT = 1 ]; then
			case "$OSTYPE"; in
				linux*)
					if type systemctl > /dev/null; then
						zgen oh-my-zsh plugins/systemd
					fi

					if [ -f /etc/os-release ]; then
						. /etc/os-release

						case "$ID"; in
							"arch"*)
								zgen oh-my-zsh plugins/archlinux
								;;
							"debian")
								zgen oh-my-zsh plugins/debian
								;;
							"ubuntu")
								zgen oh-my-zsh plugins/ubuntu
								;;
						esac
					fi
				;;
				darwin*)
					zgen oh-my-zsh plugins/macos

					if type brew > /dev/null; then
						zgen oh-my-zsh plugins/brew
					fi

					if type port > /dev/null; then
						zgen oh-my-zsh plugins/macports
					fi
				;;
			esac
		fi
	fi

	# Load the theme
	zgen load $(echo "$EG_ZSH_THEME")

	# other plugins
	for PLUGIN in "${EG_ZSH_PLUGINS[@]}"; do
		zgen load $(echo "$PLUGIN")
	done

	# system packages
	if [ -d /usr/share/zsh/site-functions ]; then
		zgen load /usr/share/zsh/site-functions
	fi

	# local system packages
	if [ -d /usr/local/share/zsh/site-functions ]; then
		zgen load /usr/local/share/zsh/site-functions
	fi

	# speedup startup
	zgen save
fi

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

# vi mode
if [[ "$EG_VI_MODE" -eq 1 ]]; then
	bindkey -v
	bindkey "^R" history-incremental-search-backward
fi

# Theme settings (powerlevel10k) are now in the p10k.zsh file
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f "${HOME}/.p10k.zsh" ] && source "${HOME}/.p10k.zsh"

# We done.
# vim: filetype=zsh