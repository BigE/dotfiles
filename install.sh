#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ "$PWD" != "$DIR" ]]
then
    echo "ERROR: Script must be run from its parent directory"
    exit 1;
fi

if [ -d $HOME/.byobu ] && [ ! -L $HOME/.byobu ]; then
    rm -Rf $HOME/.byobu.bak
    mv -f $HOME/.byobu $HOME/.byobu.bak
fi

ln -sf $DIR/bashrc $HOME/.bashrc
if [ ! -L $HOME/.byobu ]; then
    ln -sf $DIR/byobu $HOME/.byobu
fi
ln -sf $DIR/gitconfig $HOME/.gitconfig
ln -sf $DIR/gitignore $HOME/.gitignore
ln -sf $DIR/gvimrc $HOME/.gvimrc
ln -sf $DIR/vimrc $HOME/.vimrc
