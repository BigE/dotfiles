#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ "$PWD" != "$DIR" ]
then
    echo "ERROR: Script must be run from its parent directory"
    exit 1;
fi

# default options
EG_ENABLE_BASH=1
EG_ENABLE_GIT=1
EG_ENABLE_POWERLINE=1
EG_ENABLE_TMUX=1
EG_ENABLE_VIM=1
EG_ENABLE_ZSH=1

for arg in "$@"; do
    case "$arg" in
        "-h|--help")
            echo "Installer for my dotfiles"
            exit 0;
        ;;
        "--disable-bash")
            EG_ENABLE_BASH=0
        ;;
        "--disable-git")
            EG_ENABLE_GIT=0
        ;;
        "--disable-powerline")
            EG_ENABLE_POWERLINE=0
        ;;
        "--disable-tmux")
            EG_ENABLE_TMUX=0
        ;;
        "--disable-zsh")
            EG_ENABLE_ZSH=0
        ;;
    esac
done

# ensure we're up to date
git submodule update --init

if [ $EG_ENABLE_BASH -eq 1 ]; then
    echo "linking bash shell files"
    ln -sf "$DIR/bash_profile" "$HOME/.bash_profile"
    ln -sf "$DIR/bashrc" "$HOME/.bashrc"
fi

if [ $EG_ENABLE_ZSH -eq 1 ]; then
    echo "linking zsh shell files"
    ln -sf "$DIR/p10k.zsh" "$HOME/.p10k.zsh"
    ln -sf "$DIR/zshenv" "$HOME/.zshenv"
    ln -sf "$DIR/zprofile" "$HOME/.zprofile"
    ln -sf "$DIR/zshrc" "$HOME/.zshrc"
fi

if [ $EG_ENABLE_BASH -eq 1 ] || [ $EG_ENABLE_ZSH -eq 1 ]; then
    echo "linking common shell files"
    ln -sf "$DIR/commonrc" "$HOME/.commonrc"
    ln -sf "$DIR/cprofile" "$HOME/.cprofile"
    ln -sf "$DIR/env" "$HOME/.env"
fi

if [ $EG_ENABLE_GIT ]; then
    echo "linking git config and ignore"
    ln -sf "$DIR/gitconfig" "$HOME/.gitconfig"
    ln -sf "$DIR/gitignore" "$HOME/.gitignore"
fi

if [ $EG_ENABLE_POWERLINE -eq 1 ]; then
    echo "linking powerline config"
    ln -sf "$DIR/powerline" "$HOME/.config/powerline"
fi

if [ $EG_ENABLE_TMUX -eq 1 ]; then
    echo "linking tmux config"
    ln -sf "$DIR/tmux.conf" "$HOME/.tmux.conf"
fi

if [ $EG_ENABLE_VIM ]; then
    echo "linking vim config"
    ln -sf "$DIR/gvimrc" "$HOME/.gvimrc"

    if [ -d "$HOME/.vim" ]; then
        rm -Rf "$HOME/.vim.bak"
        mv -f "$HOME/.vim" "$HOME/.vim.bak"
    fi

    if [ ! -L "$HOME/.vim" ]; then
        ln -sf "$DIR/vim" "$HOME/.vim"
    fi

    ln -sf "$DIR/vimrc" "$HOME/.vimrc"
fi
