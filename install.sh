#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ "$PWD" != "$DIR" ]
then
    echo "ERROR: Script must be run from its parent directory"
    exit 1;
fi

SRC_DIR="${DIR}/src"

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

if [ $EG_ENABLE_BASH -eq 1 ] || [ $EG_ENABLE_ZSH -eq 1 ]; then
    echo "checking for .shellrc and subdirs"
    [ -d "$HOME/.shellrc" ] || (echo "creating $HOME/.shellrc" && mkdir "$HOME/.shellrc")
    [ -d "$HOME/.shellrc/env.d" ] || (echo "creating $HOME/.shellrc/env.d" && mkdir "$HOME/.shellrc/env.d")
    [ -d "$HOME/.shellrc/login.d" ] || (echo "creating $HOME/.shellrc/login.d" && mkdir "$HOME/.shellrc/login.d")
    [ -d "$HOME/.shellrc/rc.d" ] || (echo "creating $HOME/.shellrc/rc.d" && mkdir "$HOME/.shellrc/rc.d")
    echo "linking common shell files"
    ln -sf "$SRC_DIR"/shellrc/env.d/*.sh "$HOME/.shellrc/env.d/"
    ln -sf "$SRC_DIR"/shellrc/login.d/*.sh "$HOME/.shellrc/login.d/"
    ln -sf "$SRC_DIR"/shellrc/rc.d/*.sh "$HOME/.shellrc/rc.d/"
fi

if [ $EG_ENABLE_BASH -eq 1 ]; then
    echo "linking bash shell files"
    ln -sf "$SRC_DIR/bash_profile" "$HOME/.bash_profile"
    ln -sf "$SRC_DIR/bashrc" "$HOME/.bashrc"
    ln -sf "$SRC_DIR"/shellrc/env.d/*.bash "$HOME/.shellrc/env.d/"
    #ln -sf "$SRC_DIR"/shellrc/login.d/*.bash "$HOME/.shellrc/login.d/"
    ln -sf "$SRC_DIR"/shellrc/rc.d/*.bash "$HOME/.shellrc/rc.d/"
fi

if [ $EG_ENABLE_ZSH -eq 1 ]; then
    echo "linking zsh shell files"
    ln -sf "$SRC_DIR/p10k.zsh" "$HOME/.p10k.zsh"
    ln -sf "$SRC_DIR/zshenv" "$HOME/.zshenv"
    ln -sf "$SRC_DIR/zprofile" "$HOME/.zprofile"
    ln -sf "$SRC_DIR/zshrc" "$HOME/.zshrc"
    ln -sf "$SRC_DIR"/shellrc/env.d/*.zsh "$HOME/.shellrc/env.d/"
    #ln -sf "$SRC_DIR"/shellrc/login.d/*.zsh "$HOME/.shellrc/login.d/"
    ln -sf "$SRC_DIR"/shellrc/rc.d/*.zsh "$HOME/.shellrc/rc.d/"
fi

if [ $EG_ENABLE_GIT ]; then
    echo "linking git config and ignore"
    ln -sf "$SRC_DIR/gitconfig" "$HOME/.gitconfig"
    ln -sf "$SRC_DIR/gitignore" "$HOME/.gitignore"
fi

if [ $EG_ENABLE_POWERLINE -eq 1 ]; then
    echo "linking powerline config"
    ln -sf "$SRC_DIR/config/powerline" "$HOME/.config/"
fi

if [ $EG_ENABLE_TMUX -eq 1 ]; then
    echo "linking tmux config"
    ln -sf "$SRC_DIR/tmux.conf" "$HOME/.tmux.conf"
fi

if [ $EG_ENABLE_VIM ]; then
    echo "linking vim config"
    ln -sf "$SRC_DIR/gvimrc" "$HOME/.gvimrc"

    if [ ! -d "$HOME/.vim" ]; then
        echo "creating .vim folder"
        mkdir "$HOME/.vim"
    fi

    ln -sf "$SRC_DIR/vim/colors" "$HOME/.vim/"
    ln -sf "$SRC_DIR/vim/pack" "$HOME/.vim/"
    ln -sf "$SRC_DIR/vimrc" "$HOME/.vimrc"
fi
