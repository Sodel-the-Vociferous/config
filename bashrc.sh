#!/bin/bash
#
# Non-login bash-specific shell config.

## Write history out line by line, ignoring duplicates
export PROMPT_COMMAND='history -a;'
export HISTCONTROL=ignoreboth
shopt -s histappend

# Store lots of history
export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE

if [[ $- = *i* ]]
then
    ~/config/bin/tmux-client.sh && exit
fi

## Set up prompts
# Show git branch in bash prompt
parse_git_branch () {
    ref=$(git symbolic-ref HEAD 2> /dev/null)

    if [ ! $ref ]
    then
        return
    fi

    branch=$(basename $ref)

    echo "($branch) "
}
export PS1='\u@\h[$(parse_git_branch)\W]\$ '

## Load aliases
source ~/.bash_aliases;

## Set up bach completion
if [ -f "/etc/bash_completion" ]
then
    source /etc/bash_completion
fi
