#!/bin/bash

export PATH="$HOME/src/tmux:$PATH"

not_in_tmux_or_screen () {
    [[ -z $TMUX ]] &&
    [[ $TERM != screen ]] &&
    [[ $TERM != screen-256color ]]
}

tmux_session_running () {
    tmux list-sessions 2> /dev/null |
    grep TMUX_MASTER &> /dev/null
}

if ( [ "$1" = "--force" ] || not_in_tmux_or_screen )
then
    unset TMUX
    export TMUX

    # Creating a new session creates a window
    # automatically. Connecting to an existing session doesn't. But,
    # we don't want to create a second window if we're connecting to
    # the new session that we JUST created -- the session has a fresh
    # window which we can use!
    tmux_session_running &&
    NEW_WINDOW=true ||
    unset NEW_WINDOW

    tmux -2 new-session -A -s TMUX_MASTER -c "$(pwd)" \; detach

    exec tmux -2 \
        new-session -t TMUX_MASTER \; \
        $([[ $NEW_WINDOW ]] && echo new-window -c $(pwd) \;) \
        set -q destroy-unattached on
else
    exit 1
fi
