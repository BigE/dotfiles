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
    export LSCOLORS="ExGxFxdaCxDaDahbadacec"

	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"

	# Prefer GNU version, since it respects dircolors.
	if which gls &>/dev/null; then
		alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
	else
		alias ls='() { $(whence -p ls) -CFtr $@ }'
	fi
else
	alias ls='() { $(whence -p ls) -Ctr --file-type --color=auto $@ }'
fi

alias grep='() { $(whence -p grep) --color=auto $@ }'

alias la="ls -a"
alias ll="ls -l"

###############################################################################
# STARTUP
###############################################################################

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