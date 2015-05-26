#!/bin/bash
#
# Login (i.e. once-per-session) generic shell config.

## Language
LC_COLLATE=C
export LC_COLLATE
# LANG=en_CA.UTF-8
# export LANG

## Environment Variables ##

# Editors
EDITOR=emacsclient
export EDITOR
VISUAL=$EDITOR
export VISUAL
ALTERNATE_EDITOR=
export ALTERNATE_EDITOR

# Set up paths
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/lib32/usr/lib/:/usr/local/lib:/usr/local/lib64"
export LD_LIBRARY_PATH
PATH="/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/games"
export PATH
STOW_DIR="/usr/local/stow"
export STOW_DIR
GOPATH=~/src/go
export GOPATH

# Make Wine emulate 32-bit Windows.
WINEARCH=win32
export WINEARCH

# Prevent Python from cluttering my filesystem up with .pyc files
PYTHONDONTWRITEBYTECODE=true
export PYTHONDONTWRITEBYTECODE

# Setup gtags w/ exuberant ctags
GTAGSCONF=$HOME/.globalrc
export GTAGSCONF
GTAGSLABEL=ctags
export GTAGSLABEL

# Add extra search paths for GTAGS
GTAGSLIBPATH=~/src/navsim/RG5/lib/
export GTAGSLIBPATH

# Connect to dbus
[[ -z $DBUS_SESSION_BUS_ADDRESS ]] &&
    which dbus-launch @> /dev/null &&
    eval $(dbus-launch --sh-syntax --autolaunch $(cat /etc/machine-id))

# Use keychain as a GPG and SSH agent.
eval $(keychain --inherit local-once --quiet --eval)

# Start emacs daemon if one isn't already running
if [[ $OS = Windows_NT ]]
then
    EMACSD=emacs
else
    EMACSD=emacs-x11
fi

pgrep -f "emacs(-gtk|-x11|-w32)? --daemon" &>/dev/null ||
nohup $EMACSD --daemon &> /dev/null &

# Start pulseaudio
which pulseaudio &> /dev/null &&
pulseaudio --start &> /dev/null &

# Make sure a dying shell doesn't kill these background processes.
[[ $SHELL = /bin/bash ]] && disown -a
