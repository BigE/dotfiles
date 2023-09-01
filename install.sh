#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ "$PWD" != "$DIR" ]]
then
    echo "ERROR: Script must be run from its parent directory"
    exit 1;
fi

# ensure we're up to date
git submodule update --init

if [ -d $HOME/.vim ]; then
    rm -Rf $HOME/.vim.bak
    mv -f $HOME/.vim $HOME/.vim.bak
fi

ln -sf $DIR/bashrc $HOME/.bashrc
ln -sf $DIR/commonrc $HOME/.commonrc
ln -sf $DIR/powerline $HOME/.config/powerline
ln -sf $DIR/cprofile $HOME/.cprofile
ln -sf $DIR/gitconfig $HOME/.gitconfig
ln -sf $DIR/gitignore $HOME/.gitignore
ln -sf $DIR/gvimrc $HOME/.gvimrc
ln -sf $DIR/p10k.zsh $HOME/.p10k.zsh
ln -sf $DIR/profile $HOME/.profile
if [ ! -L $HOME/.vim ]; then
    ln -sf $DIR/vim $HOME/.vim
fi
ln -sf $DIR/tmux.conf $HOME/.tmux.conf
ln -sf $DIR/vimrc $HOME/.vimrc
ln -sf $DIR/zprofile $HOME/.zprofile
ln -sf $DIR/zshrc $HOME/.zshrc
