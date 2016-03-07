# Eric Gach's bashrc file

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

###############################################################################
# these are all my custom functions
###############################################################################

function __eg_bg_color()
{
    echo $(tput setab $1)
}

function __eg_command_exists () {
    command -v "$1" &> /dev/null ;
}

function __eg_fg_color()
{
    echo $(tput setaf $1)
}

function __eg_pwd()
{
    echo $(pwd)
}

function __eg_load()
{
    echo $(uptime | awk '{print $(NF - 2)}')
}

function __eg_loads()
{
    echo $(uptime | awk '{print $(NF - 2) $(NF - 1) $NF}')
}

function __eg_loads_display()
{
    load=$(__eg_load)
    cpus=$(grep processor /proc/cpuinfo | wc -l)
    cpus="$cpus.00"
    if __eg_command_exists bc && (( $(echo "${load%?}" '>' "$cpus" | bc -l ) ))
    then
        echo -ne $(__eg_bg_color 1)${GREEN}${BOLD}
    fi
    echo -n $(__eg_loads)
    echo -ne ${RESET}
}

function __eg_test_unicode()
{
    echo -ne "\xe2\x88\xb4\033[6n\033[1K\r"
    read -d R foo
    echo -ne "\033[1K\r"
    echo -e "${foo}" | cut -d \[ -f 2 | cut -d";" -f 2 | (
        read UNICODE
        [ $UNICODE -eq 2 ] && return 0
        [ $UNICODE -ne 2 ] && return 1
    )
}

function __eg_virtualenv()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv="${VIRTUAL_ENV##*/}"
    else
        venv=''
    fi
    [[ -n "$venv" ]] && echo " [env:$venv]"
}

function __eg_prompt_command()
{
    case $TERM in
        xterm*|rxvt*|Eterm)
            echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"
        ;;
        screen)
            echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"
        ;;
    esac


    #   Add all the accessories below ...
    local temp="${USER}@${HOSTNAME}$(__eg_virtualenv)$(__eg_git_svn_ps1) [$(__eg_pwd)][$(__eg_loads)]"

    let fillsize=${COLUMNS}-${#temp}
    if [ "$fillsize" -gt "0" ]
    then
        fill="                                                                                                                                                                                                                                        "
        #   Its theoretically possible someone could need more
        #   dashes than above, but very unlikely!  HOWTO users,
        #   the above should be ONE LINE, it may not cut and
        #   paste properly
        fill="${fill:0:${fillsize}}"
        newPWD="$(__eg_pwd)"
    fi

    if [ "$fillsize" -lt "0" ]
    then
        fill=""
        let cut=3-${fillsize}
        newPWD="...${__eg_pwd:${cut}}"
    fi
}

# git/Subversion prompt function
__eg_git_svn_ps1() {
    local s=
    if [[ -d ".svn" ]] ; then
        local r=`__eg_svn_rev`
        local b=`__eg_svn_branch`
        s=" [svn:$b:$r]"
    elif [[ -d .git ]] && __eg_function_exists __git_ps1; then
        s=`__git_ps1 " (git:%s)"`
    fi
    echo -n "$s"
}

# outputs the current trunk, branch, or tag
__eg_svn_branch() {
    local url=
    if [[ -d .svn ]]; then
        url=`svn info | awk '/URL:/ {print $2}'`
        if [[ $url =~ trunk ]]; then
            echo trunk
        elif [[ $url =~ /branches/ ]]; then
            echo $url | sed -e 's#^.*/\(branches/.*\).*$#\1#'
        elif [[ $url =~ /tags/ ]]; then
            echo $url | sed -e 's#^.*/\(tags/.*\).*$#\1#'
        fi
    fi
}

# outputs the current revision
__eg_svn_rev() {
    local r=$(svn info | awk '/Revision:/ {print $2}')

    if [ ! -z $SVN_SHOWDIRTYSTATE ]; then
        local svnst flag
        svnst=$(svn status | grep '^\s*[?ACDMR?!]')
        [ -z "$svnst" ] && flag=*
        r=$r$flag
    fi
    echo $r
}

# psgrep ;)
function __eg_psgrep()
{
    if [ "$#" -eq 1 ]
    then
        ps aux | grep -v grep | grep --color ${@:1}
    else
        ps $1 | grep -v grep | grep --color ${@:2}
    fi

}

function __eg_function_exists()
{
    declare -f -F $1 > /dev/null
    return $?;
}

###############################################################################
# environment setup
###############################################################################

# import the inital profile
if [[ -f /etc/profile ]]
then
    source /etc/profile
fi

#exports
if __eg_command_exists vim
then
    export EDITOR="vim"
    export DIETY=$EDITOR # haha
elif __eg_command_exists nano
then
    export EDITOR="nano" # not diety
fi

# import my local bin directory
if [[ -d $HOME/.local/bin ]]
then
    export PATH=$HOME/.local/bin:$PATH
fi

#Enable colors for ls, etc. Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]]
then
    # local directory colors
    eval `dircolors -b ~/.dir_colors`
elif [[ -f /etc/DIR_COLORS ]]
then
    # This is for Gentoo/RedHat systems
    eval `dircolors -b /etc/DIR_COLORS`
else
    # Added this in for Debian/Ubuntu systems
    eval `dircolors`
fi

# show more git info - leaving these disabled, should enable in .bashrc_local
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=

# if you want to see svn modifications:
export SVN_SHOWDIRTYSTATE=1

#colors
# 2016-02-11 updated to use tput & setaf/setab to set colors
RESET="$(tput sgr0)"
BOLD="$(tput bold)"
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
PURPLE="$(tput setaf 5)"
TEAL="$(tput setaf 6)"
WHITE="$(tput setaf 7)"


###############################################################################
# virtualenv setup
###############################################################################

# I make my own
export VIRTUAL_ENV_DISABLE_PROMPT=1

# if not already set, virtualenvs should reside here
if [ -z "$WORKON_HOME" ]; then
    export WORKON_HOME=~/.virtualenvs
fi

if [[ -f ~/.local/bin/virtualenvwrapper.sh ]]; then
    source ~/.local/bin/virtualenvwrapper.sh
elif [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
elif [[ -f /bin/virtualenvwrapper.sh ]]; then
    source /bin/virtualenvwrapper.sh
fi

###############################################################################
# alias setup
###############################################################################

alias grep="grep --color"
alias ls="ls -h --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias rm="rm -i" # use -i by default to make sure we want to delete it
alias psgrep=__eg_psgrep

###############################################################################
# prompt setup
###############################################################################

__eg_test_unicode
if [ $? -eq 0 ];
then
    UNICODE_SUPPORT=1
else
    UNICODE_SUPPORT=0
fi

PROMPT_COMMAND="__eg_prompt_command"
if [ $UNICODE_SUPPORT -eq 1 ];
then
    PROMPT=$'\xe2\x8f\xa9'
else
    PROMPT='$'
fi

export PS1="\[${GREEN}\]\[${BOLD}\]${USER}\[${BLUE}\]@\[${GREEN}\]${HOSTNAME}\[${RESET}\] \
\[${BLUE}\]\[${BOLD}\][\[${RESET}\]\[$(__eg_fg_color 102)\]\${newPWD}\[${RESET}\]\[${BLUE}\]\[${BOLD}\]]\
\[$(__eg_fg_color 1)\]\$(__eg_git_svn_ps1)\
\[${TEAL}\]\$(__eg_virtualenv)\
\[${RESET}\]\$fill\
\[${BLUE}\]\[${BOLD}\][\[${RESET}\]\[$(__eg_fg_color 202)\]\$(__eg_loads_display)\[${BLUE}\]\[${BOLD}\]]\
\[${RESET}\]\n$PROMPT "

###############################################################################
# import local settings
###############################################################################

if [[ -f $HOME/.bashrc_local ]]
then
    source $HOME/.bashrc_local
fi
