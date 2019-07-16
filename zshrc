# My custom zshrc using zgen
#zmodload zsh/zprof

zsh_wifi_signal(){
  local signal=""
  if which nmcli &> /dev/null; then
    signal=$(nmcli device wifi | grep yes | awk '{print $8}')
  elif [[ $OSTYPE = (darwin)* ]]; then
    signal=$(echo "2*($(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | awk '{print $2}') + 100)" | bc)
  fi

  if [[ ! -z "$signal" ]]; then
    local color='%F{yellow}'
    [[ $signal -gt 75 ]] && color='%F{green}'
    [[ $signal -lt 50 ]] && color='%F{red}'
    echo -n "%{$color%}$signal%% \uf1eb%{%f%}" # \uf230 is 
  fi
}

if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	export -U PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# start the powerline daemon
if which powerline-daemon &> /dev/null; then
	powerline-daemon -q
fi

# Generic settings
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="black"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"

POWERLEVEL9K_MODE="nerdfont-complete"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator os_icon context dir dir_writable vcs pyenv rbenv virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time_joined background_jobs load ram custom_wifi_signal battery ssh)

POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=$'\u256D'$'\U2500'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=$'\u2570'$'\uF460 '
POWERLEVEL9K_TIME_FORMAT="%D{\uF017 %T}"

ZSH_TMUX_ITERM2=false
if [ ! -z $ITERM_SESSION_ID ]; then
	# I iterm2 - disables loading of ~/.tmux.conf - https://github.com/robbyrussell/oh-my-zsh/pull/1903
  ZSH_TMUX_ITERM2=true
fi

# Config for zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]='bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

export PYENV_ROOT="$HOME/.pyenv"

###############################################################################
# OPTIONS
###############################################################################

if [ -z "$HISTFILE" ]; then
	export HISTFILE="$HOME/.zsh_history"
fi

if [ -z "$SAVEHIST" ]; then
	export SAVEHIST=10000
fi

export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones. 

###############################################################################
# ALIASES
###############################################################################

# Directory coloring
if [[ $OSTYPE = (darwin|freebsd)* ]]; then
	export CLICOLOR="YES" # Equivalent to passing -G to ls.
	export LSCOLORS="ExGxFxdaCxDaDahbadacec"
	# Pulled this from ubuntu, also updated LSCOLORS to match
	export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"


	# MacPorts
	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

	# Prefer GNU version, since it respects dircolors.
	if which gls &>/dev/null; then
		alias ls='() { $(whence -p gls) -Ch --file-type --color=auto $@ }'
	else
		alias ls='() { $(whence -p ls) -CFh $@ }'
	fi
else
	alias ls='() { $(whence -p ls) -Ch --file-type --color=auto $@ }'
fi

alias rm='() { $(whence -p rm) -i $@ }'
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

###############################################################################
# PLUGINS
###############################################################################

# Include the common things before we load it all up
[ -f ~/.commonrc ] && source ~/.commonrc

# Install zgen and plugins
[ -d ~/.zgen ] || git clone https://github.com/tarjoilija/zgen.git ~/.zgen
source ~/.zgen/zgen.zsh

# if the init script doesn't exist
if ! zgen saved; then

	# other plugins
	zgen load zsh-users/zsh-completions
	zgen load zsh-users/zsh-syntax-highlighting

	# init oh-my-zsh core
	zgen oh-my-zsh
	# pull in plugins from oh-my-zsh
	zgen oh-my-zsh plugins/command-not-found
	zgen oh-my-zsh plugins/django
	zgen oh-my-zsh plugins/docker
	zgen oh-my-zsh plugins/docker-compose
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/git-flow-avh
	zgen oh-my-zsh plugins/pip
	zgen oh-my-zsh plugins/sudo
	#zgen oh-my-zsh plugins/tmux
	zgen oh-my-zsh plugins/virtualenvwrapper
	zgen oh-my-zsh plugins/vscode
	zgen oh-my-zsh plugins/wp-cli
	zgen oh-my-zsh plugins/yarn

	if [[ $OSTYPE = (linux)* ]]; then
		if type pacman > /dev/null; then
			zgen oh-my-zsh plugins/archlinux
		fi

		if type dnf > /dev/null; then
			zgen oh-my-zsh plugins/dnf
		fi
	fi

	if [[ $OSTYPE = (darwin)* ]]; then
		zgen oh-my-zsh plugins/osx

		if type brew > /dev/null; then
			zgen oh-my-zsh plugins/brew
		fi

		if type port > /dev/null; then
			zgen oh-my-zsh plugins/macports
		fi
	fi

	zgen oh-my-zsh plugins/pyenv
	zgen oh-my-zsh plugins/nvm
	zgen oh-my-zsh plugins/rvm

	# theme it up bitches
	#zgen load bhilburn/powerlevel9k powerlevel9k
	zgen load romkatv/powerlevel10k powerlevel10k

	# speedup startup
	zgen save
fi

###############################################################################
# STARTUP
###############################################################################

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#zprof
# We done.
# vim: ft=zsh
