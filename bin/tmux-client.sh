#!/bin/bash

no_tmux_clients () {
    [[ $(tmux list-sessions | wc -l) -lt 2 ]]
}

tmux_client () {
    no_tmux_clients && tmux new-session -t TMUX_BG ||
    tmux new-session -t TMUX_BG \; new-window -c $(pwd)
}

[[ $TERM != screen ]] &&
[[ $TERM != screen-256color ]] &&
(tmux new-session -A -s TMUX_BG \; detach
tmux_client)
