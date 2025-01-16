#!/bin/bash


# Setup the virtualenv wrapper if it exists
if [[ -f ~/.local/bin/virtualenvwrapper.sh ]]; then
	source ~/.local/bin/virtualenvwrapper.sh
elif [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
elif [[ -f /bin/virtualenvwrapper.sh ]]; then
	source /bin/virtualenvwrapper.sh
elif [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi

# vim: filetype=bash