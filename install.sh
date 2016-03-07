#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ "$PWD" != "$DIR" ]]
then
    echo "ERROR: Script must be run from its parent directory"
    exit 1;
fi

if [ -d $HOME/.byobu/ ]
then
    mv $HOME/.byobu/ $HOME/.byobu.bak
fi

ln -sf $DIR/bashrc $HOME/.bashrc
ln -sf $DIR/byobu/ $HOME/.byobu
ln -sf $DIR/gitconfig $HOME/.gitconfig
ln -sf $DIR/gvimrc $HOME/.gvimrc
ln -sf $DIR/vimrc $HOME/.vimrc
