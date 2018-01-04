# My custom zshrc using zplug

zsh_wifi_signal(){
  local signal=""
  if which nmcli &> /dev/null; then
    signal=$(nmcli device wifi | grep yes | awk '{print $8}')
  elif [[ $OSTYPE = (darwin)* ]]; then
    signal=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | awk '{print $2}' | tr -d -)
  fi

  if [[ ! -z "$signal" ]]; then
    local color='%F{yellow}'
    [[ $signal -gt 75 ]] && color='%F{green}'
    [[ $signal -lt 50 ]] && color='%F{red}'
    echo -n "%{$color%}$signal \uf1eb%{%f%}" # \uf230 is 
  fi
}

POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="black"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"

POWERLEVEL9K_MODE="nerdfont-complete"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator os_icon context dir dir_writable vcs rbenv virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time_joined background_jobs load ram custom_wifi_signal battery ssh)

POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "
POWERLEVEL9K_TIME_FORMAT="%D{\uF017 %T}"

ZSH_TMUX_ITERM2=false
if [ -n $ITERM_SESSION_ID ]; then
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

###############################################################################
# PLUGINS
###############################################################################

# We need zplug to function
[ -d ~/.zplug ] || git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/grep", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/termsupport", from:oh-my-zsh
zplug "plugins/capistrano", from:oh-my-zsh, if:"which cap"
zplug "plugins/git", from:oh-my-zsh, if:"which git"
zplug "plugins/git-flow", from:oh-my-zsh, if:"which git"
zplug "plugins/sudo", from:oh-my-zsh, if:"which sudo"
zplug "plugins/tmux", from:oh-my-zsh, if:"which tmux"
zplug "plugins/virtualenvwrapper", from:oh-my-zsh, if:"which python"
zplug "plugins/yarn", from:oh-my-zsh, if:"which yarn"

if [[ $OSTYPE = (linux)* ]]; then
	zplug "plugins/archlinux", from:oh-my-zsh, if:"which pacman"
	zplug "plugins/dnf",       from:oh-my-zsh, if:"which dnf"
fi

if [[ $OSTYPE = (darwin)* ]]; then
	zplug "plugins/osx",      from:oh-my-zsh
	zplug "plugins/brew",     from:oh-my-zsh, if:"which brew"
	zplug "plugins/macports", from:oh-my-zsh, if:"which port"
fi

zplug "zsh-users/zsh-syntax-highlighting", defer:3

###############################################################################
# ALIASES
###############################################################################

# Directory coloring
if [[ $OSTYPE = (darwin|freebsd)* ]]; then
	export CLICOLOR="YES" # Equivalent to passing -G to ls.
  # I don't like whatever colors are loaded, this gets us back to defaults
  export LSCOLORS="ExGxFxdaCxDaDahbadacec"
  # Pulled this from ubuntu, updated LSCOLORS to match
  export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"


  # MacPorts
	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

	# Prefer GNU version, since it respects dircolors.
	if which gls &>/dev/null; then
		alias ls='() { $(whence -p gls) -Ctrh --file-type --color=auto $@ }'
	else
		alias ls='() { $(whence -p ls) -CFtrh $@ }'
	fi
else
	alias ls='() { $(whence -p ls) -Ctrh --file-type --color=auto $@ }'
fi

###############################################################################
# STARTUP
###############################################################################

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# Include the common things before we load it all up
[ -f ~/.commonrc ] && source ~/.commonrc

# Check to ensure all plugins are installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load all the plugins
zplug load

# We done.
# vim: ft=zsh