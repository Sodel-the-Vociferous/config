#!/bin/bash

export PATH="$HOME/src/tmux:$PATH"

not_in_tmux_or_screen () {
    [[ -z $TMUX ]] &&
    [[ $TERM != screen ]] &&
    [[ $TERM != screen-256color ]]
}

new_tmux_client () {
    exec tmux -2 new-session -t TMUX_MASTER \; \
        new-window -c $(pwd) \; \
        set -q destroy-unattached on
}

( [ "$1" = "force" ] || not_in_tmux_or_screen ) &&
unset TMUX &&
export TMUX &&
tmux -2 new-session -A -s TMUX_MASTER \; detach &&
new_tmux_client
