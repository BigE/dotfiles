#!/bin/sh

# DON'T EDIT THIS FILE
# If you would like a common place to put things, please create a ~/.localrc
# since this file will include it after all variables are defined.

###############################################################################
# OPTIONS
###############################################################################

[ -z "$LESS" ] && export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
[ -z "$PAGER" ] && command -v less > /dev/null && export PAGER="less"


###############################################################################
# ALIASES
###############################################################################

# Directory coloring

 case "$OSTYPE" in
	darwin*|freebsd*|linux-musl*)
		export CLICOLOR="YES" # Equivalent to passing -G to ls.
		export LSCOLORS="ExGxFxdaCxDaDahbadacec"
		# Pulled this from ubuntu, also updated LSCOLORS to match
		export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

		# Prefer GNU version, since it respects dircolors.
		if command -v gls > /dev/null; then
			alias ls='gls -Ch --file-type --color=auto'
		else
			alias ls='ls -CFh'
		fi
	;;
	*)
		alias ls='ls -Ch --file-type --color=auto'
	;;
esac

alias rm='rm -i' # use -i by default for confirmation

# Capture output using trace
__eg_capture() {
	if [ -n "$OSTYPE" ] && expr "$OSTYPE" : 'darwin' > /dev/null ; then
		sudo dtrace -p "$1" -qn '
			syscall::write*:entry
			/pid == $target && arg0 == 1/ {
				printf("%s", copyinstr(arg1, arg2));
			}
		'
	elif expr "$OSTYPE" : "linux" ; then
		sudo strace -p"$1" -s9999 -e write
	fi
}

alias capture=__eg_capture

if [ -n "$OSTYPE" ] && expr "$OSTYPE" : 'darwin' > /dev/null ; then
	__eg_mysql() {
		if [ -z "$1" ] && [ -z "$EG_MYSQL_OLD_PATH" ]; then
			echo "You must specify the MySQL version";
			return;
		elif [ -n "$1" ] && [ ! -d "/usr/local/opt/mysql@${1}" ]; then
			echo "MySQL version ${1} is not installed";
			return;
		fi

		version="$1"

		if [ -n "$EG_MYSQL_OLD_PATH" ]; then
			export PATH="$EG_MYSQL_OLD_PATH"
			unset EG_MYSQL_OLD_PATH
		fi

		if [ -n "$version" ]; then
			export EG_MYSQL_OLD_PATH="$PATH"
			export PATH="/usr/local/opt/mysql@${version}/bin:$PATH"
		fi
	}

	alias mysqlenv=__eg_mysql
fi

###
# Combines `ps` and `grep` to easily search processes. To pass arguments to ps
# place them before the search term: `__eg_psgrep aux httpd` Simply calling the
# function and passing a search term will execute `ps aux`
##
__eg_psgrep()
{
	for search in "$@"; do
		:
	done

	if [ "$#" -eq 1 ]
	then
		ps aux | head -n1; ps aux | grep -v grep | grep --color=always "${search-}"
	else
		args=""
		for arg  in "$@"; do
			if [ "$arg" != "${search-}" ]; then
				args="$args $arg"
			fi
		done

		echo "${args}" | xargs ps | head -n1; echo "${args}" | xargs ps | grep -v grep | grep --color=always "${search-}"
	fi

}

# make easier use of the awesomeness
alias psgrep=__eg_psgrep

if expr "$OSTYPE" : 'linux' > /dev/null; then
	# Unfortunately, OSX doesn't provide a ps version that uses size
	__eg_pssize()
	{
		for search in "$@"; do
			:
		done

		if [ "$#" -eq 1 ]; then
			command="__eg_psgrep -eo size,pid,user,command --sort -size ${search-}"
		else
			command="ps -eo size,pid,user,command --sort -size"
		fi

		eval "$command" | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=2 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'
	}

	alias pssize=__eg_pssize
fi


###############################################################################
# LOCALRC
###############################################################################

# Import localrc (similar to common)
[ -f "${HOME}/.localrc" ] && . "${HOME}/.localrc"

# If we're bash, import .bashrc_local
[ -n "$BASH_VERSION" ] && [ -f "${HOME}/.bashrc_local" ] && . "${HOME}/.bashrc_local"

# If we're zsh, import .zshrc_local
[ -n "$ZSH_VERSION" ] && [ -f "${HOME}/.zshrc_local" ] && . "${HOME}/.zshrc_local"


###############################################################################
# PATH
###############################################################################

# On MacOS we want to use the GNU programs from homebrew
if [ -n "$BREW_LOCATION" ]; then
	if [ -d "$($BREW_LOCATION --prefix coreutils)" ]; then
		PATH="$($BREW_LOCATION --prefix coreutils)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix coreutils)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU find
	if [ -d "$($BREW_LOCATION --prefix findutils)" ]; then
		PATH="$($BREW_LOCATION --prefix findutils)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix findutils)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU awk
	if [ -d "$($BREW_LOCATION --prefix gawk)" ]; then
		PATH="$($BREW_LOCATION --prefix gawk)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gawk)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU sed
	if [ -d "$($BREW_LOCATION --prefix gnu-sed)" ]; then
		PATH="$($BREW_LOCATION --prefix gnu-sed)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gnu-sed)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi

	# On MacOS we want to use the GNU tar
	if [ -d "$($BREW_LOCATION --prefix gnu-tar)" ]; then
		PATH="$($BREW_LOCATION --prefix gnu-tar)/libexec/gnubin:$PATH"
		export PATH
		MANPATH="$($BREW_LOCATION --prefix gnu-tar)/libexec/gnuman:$MANPATH"
		export MANPATH
	fi
fi

if [ -z "$PHPENV_ROOT" ] && [ -d "${HOME}/.phpenv" ]; then
	export PHPENV_ROOT="${HOME}/.phpenv"
fi

if [ -n "$PHPENV_ROOT" ]; then
	export PATH="${PHPENV_ROOT}/bin:${PATH}"
fi

# vendor/bin/ for composer projects - see http://getcomposer.org
# ~/.local/bin for local stuffs
export PATH="./vendor/bin:${HOME}/.composer/vendor/bin:${HOME}/.local/bin:${PATH}"

###############################################################################
# INITALIZATION
###############################################################################

# Setup phpenv if it exists
if [ -n "$PHPENV_ROOT" ]; then
	eval "$("${PHPENV_ROOT}"/bin/phpenv init -)"
fi

# start the powerline daemon, if available
if command -v powerline-daemon > /dev/null; then
	POWERLINE_CONFIG_COMMAND="$(command -v powerline-config)"
	export POWERLINE_CONFIG_COMMAND
	powerline-daemon -q
fi

# fin
# vim: filetype=sh
