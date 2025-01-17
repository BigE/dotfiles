#!/bin/bash


################################################################################
# PS1 - override this in ~/.bashrc_ps1, I will import it before exporting PS1
################################################################################

PS1="${EG_TITLEBAR}\[$BOLD$GREEN\]${USER}\[$BLUE\]@\[$GREEN\]${HOSTNAME}\[$RESET\]"
PS1+="\[$BOLD$RED\]\$EG_LAST_EXIT\[$RESET\]"
PS1+=" \[$BOLD$BLUE\][\[$(__eg_fg_color 102)\]\$EG_PWD\[$BLUE\]]\[$RESET\]"
PS1+='$([[ -z "$(__eg_vcs_ps1)" ]] || echo -n \[$BOLD$BLUE\] \(\[$TEAL\]$(__eg_vcs_ps1_type):\[$RED\]$(__eg_vcs_ps1)\[$BLUE\]\)\[$RESET\])'
PS1+='$([[ -z "$(__eg_virtualenv_ps1)" ]] || echo -n \[$BOLD$BLUE\] [\[$TEAL\]env:\[$PURPLE\]$(__eg_virtualenv_ps1)\[$BLUE\]]\[$RESET\])'
PS1+="\$EG_FILL"
PS1+='$([[ -z $EG_DATETIME ]] || echo -n \[$BOLD$BLUE\][\[$TEAL\]$EG_DATETIME\[$BLUE\]]\[$RESET\])'
PS1+="\[$BOLD$BLUE\][\[$(__eg_fg_color 202)\]\$(__eg_loads)\[$BLUE\]]\[$RESET\]"
PS1+="\n"
PS1+='$([[ $EG_LAST_EXIT_CODE -eq 0 ]] || echo -n \[$RED\])' # simply turns the prompt red when last exit was not 0
PS1+="\${EG_PROMPT_SYMBOL}\[$(tput sgr0)\] "

################################################################################
# PROMPT_COMMAND
################################################################################
export PROMPT_COMMAND=__eg_prompt_command

export PS1

# vim: filetype=bash