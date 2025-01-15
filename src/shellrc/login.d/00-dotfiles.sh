#!/bin/sh


# Common profile things that can be done between bash/zsh

# Homebrew
if [ -n "${OSTYPE}" ] && [ "${OSTYPE#darwin}" != "${OSTYPE}" ]; then
    if [ "$(arch)" = "arm64" ]; then
        # if homebrew is installed in the Rosetta location, remove it from the path
        if [ -f /usr/local/bin/brew ]; then
            export PATH="${PATH#/usr/local/bin:}"
        fi
        [ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        [ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Load RVM into a shell session *as a function*
[ -s "$HOME/.rvm/scripts/rvm" ] && . "${HOME}/.rvm/scripts/rvm"

# Load pyenv the new way
if [ -z "$PYENV_ROOT" ] && [ -f "$HOME/.pyenv/bin/pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
fi

if [ -n "$PYENV_ROOT" ] && [ -f "$PYENV_ROOT/bin/pyenv" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    if (pyenv --version | grep -q "pyenv 2."); then
        eval "$(pyenv init --path)"
    else
        # older version of pyenv without path support
        export ZSH_PYENV_QUIET=true
    fi
fi

# vim: filetype=sh
