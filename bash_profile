#!/bin/bash

# Do BASH specific things here
[ -f "${HOME}/.env" ] && source "${HOME}/.env" # load environment

[ -f "${HOME}/.cprofile" ] && source "${HOME}/.cprofile" # load common profile settings

# vim: ft=bash