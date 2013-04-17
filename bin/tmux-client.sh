#!/bin/bash

not_in_tmux_or_screen () {
    [[ -z $TMUX ]] &&
    [[ $TERM != screen ]] &&
    [[ $TERM != screen-256color ]]
}

no_tmux_clients () {
    [[ ! "$(tmux list-sessions | egrep -i 'attached.$')" ]]
}

new_tmux_client () {
    if no_tmux_clients
    then
        exec tmux new-session -t TMUX_MASTER \; \
            set -q destroy-unattached on
    else
        exec tmux new-session -t TMUX_MASTER \; \
            new-window -c $(pwd) \; \
            set -q destroy-unattached on
    fi
}

not_in_tmux_or_screen &&
tmux new-session -A -s TMUX_MASTER \; detach &&
new_tmux_client
