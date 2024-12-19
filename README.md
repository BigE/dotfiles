# dotfiles
My collection of dotfiles that I've put together through the years. Simple
installer script just symlinks the files to your home folder. The installer
**is** destructive as it uses `ln -sf` when linking.

## installation
    cd /path/to/dotfiles
    ./install.sh

## customization
There are many levels of customization that you can use with this setup. This
setup starts by loading the env files first for basic environment setup. There
are two files that can be created that will be automatically included if they
exist. The two files are `~/.env.local` and `~/.localrc`

### ZSH loading order
- `~/.zshenv`
- `~/.env`
- `~/.env.local` (optional)
- `~/.zprofile`
- `~/.cprofile`
- `~/.zshrc`
- `~/.commonrc`
- `~/.localrc` (optional)

### Bash loading order
- `~/.bash_profile`
- `~/.env`
- `~/.env.local` (optional)
- `~/.cprofile`
- `~/.bashrc`
- `~/.commonrc`
- `~/.localrc` (optional)

