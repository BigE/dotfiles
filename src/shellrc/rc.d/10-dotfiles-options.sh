#!/bin/sh


###############################################################################
# OPTIONS
###############################################################################

[ -z "$LESS" ] && export LESS="--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS"
[ -z "$PAGER" ] && command -v less > /dev/null && export PAGER="less"

# vim: filetype=sh
