#!/bin/bash

export PATH="$HOME/src/tmux:$PATH"

not_in_tmux_or_screen () {
    [[ -z $TMUX ]] &&
    [[ $TERM != screen ]] &&
    [[ $TERM != screen-256color ]]
}

no_tmux_clients () {
    MASTER_GROUP=$(tmux list-sessions |
        grep "TMUX_MASTER:" |
        egrep -o "group [0-9]+")

    if [ -z "$MASTER_GROUP" ]
    then
        return 0
    fi

    NUM_ATTACHED=$(tmux list-sessions |
        grep "$MASTER_GROUP" |
        grep attached |
        wc -l)

    [ $NUM_ATTACHED -eq 0 ]
}

new_tmux_client () {
    if no_tmux_clients
    then
        exec tmux -2 new-session -t TMUX_MASTER \; \
            set -q destroy-unattached on
    else
        exec tmux -2 new-session -t TMUX_MASTER \; \
            new-window -c $(pwd) \; \
            set -q destroy-unattached on
    fi
}

( [ "$1" = "force" ] || not_in_tmux_or_screen ) &&
unset TMUX &&
export TMUX &&
tmux -2 new-session -A -s TMUX_MASTER \; detach &&
new_tmux_client
