#!/bin/bash
#
# Non-login bash-specific shell config.

if [[ $OS = Windows_NT ]]
then
	export TERM=cygwin
fi

## Write history out line by line, ignoring duplicates
export PROMPT_COMMAND='history -a;'
export HISTCONTROL=ignoreboth
shopt -s histappend

# Don't expand "!" to a line in bash history. I never use this
# feature, and not being able to use unescaped bangs in double-quoted
# strings is annoying.
set +o histexpand

# Store lots of history
export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE

# Actively check the terminal size.
shopt -s checkwinsize

# Disable annoying Ctl-S/Ctl-Q
stty stop ''
stty start ''
stty -ixon
stty -ixoff

if [[ $- = *i* ]]
then
    ~/config/session-scripts/tmux-client.sh && exit
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
if [ -f "/usr/share/bash-completion/bash_completion" ]
then
    source /usr/share/bash-completion/bash_completion
fi
