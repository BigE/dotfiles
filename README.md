# dotfiles
My collection of dotfiles that I've put together through the years. Simple
installer script just symlinks the files to your home folder. The installer
**is** destructive as it uses `ln -sf` when linking.

## configuration
Recently this has been rewritten to use a modified version of the
[conf.d format](https://chr4.org/posts/2014-09-10-conf-dot-d-like-directories-for-zsh-slash-bash-dotfiles/)
for shell files. It also follows the loading order for dotfiles as seen
[here](https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/)
through the respective bash/zsh files. The env.d directory is loaded every time
while the login.d and rc.d directories are profile/interactive respectively
through their shells loading process. The ~/.shellrc directory is where all of
the files will be stored. This directory will be created through the installer
as well as the subdirectories of env.d, login.d and rc.d.

### overriding
No matter if it's bash or zsh, the order of loading files is the same. First
the script will attempt to load the env.d files. If the shell is a login shell,
then it will load files from the login.d folder. Finally, if the shell is
interactive it will load all files from the rc.d folder. It loads in the a
default ASCII order, meaning that the order would be something like this:

* 00-script.sh
* 10-script.sh
* 20-script.sh

To override anything in 00-script.sh you would create 01-custom.sh, or any
number combination of 0#-<name>.sh so it would load after 00. Take a look into
each script at each level to get a better understanding of what you can control
and where.

## installation
The installation script must be run from the directory that the dotfiles repo
exists in. If you want to find out all of the options of the script, just use
the `-h` or `--help` options when running `install.sh`

    cd /path/to/dotfiles
    ./install.sh


### usage
    install.sh [-h|--help] [--disable-bash] [--disable-git] [--disable-powerline]
               [--disable-tmux] [--disable-zsh]

    Simple installer script for my dotfiles. By default all options are enabled and
    linked unless they are explicitly disabled. Please view the README.md or view
    the project at https://github.com/BigE/dotfiles for more details.

        -h|--help           Display this message and exit
        --disable-bash      Disable linking of bash specific scripts
        --disable-git       Disable linking of git configuration files
        --disable-powerline Disable linking of the powerline config
        --disable-tmux      Disable linking of the tmux config
        --disable-zsh       Disable linking of zsh specific scripts
