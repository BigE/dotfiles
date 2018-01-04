#!/bin/sh

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
ln -sf $DIR/gitconfig $HOME/.gitconfig
ln -sf $DIR/gitignore $HOME/.gitignore
ln -sf $DIR/gvimrc $HOME/.gvimrc
if [ ! -L $HOME/.vim ]; then
    ln -sf $DIR/vim $HOME/.vim
fi
ln -sf $DIR/vimrc $HOME/.vimrc
ln -sf $DIR/zshrc $HOME/.zshrc