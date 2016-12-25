#!/bin/bash
#
# Login (i.e. once-per-session) generic shell config.

## Language
LC_COLLATE=C
export LC_COLLATE
# LANG=en_CA.UTF-8
# export LANG

## Environment Variables ##

# X
XAUTHORITY=$HOME/.Xauthority
export XAUTHORITY

# Editors
EDITOR=emacsclient
export EDITOR
VISUAL=$EDITOR
export VISUAL
ALTERNATE_EDITOR=
export ALTERNATE_EDITOR

EMACS_TOOLKIT=x11
export EMACS_TOOLKIT

# GET OUT OF MY FACE
PINENTRY_USER_DATA="USE_CURSES=1"
export PINENTRY_USER_DATA

# Set up paths
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/lib32/usr/lib/:/usr/local/lib:/usr/local/lib64"
export LD_LIBRARY_PATH
PATH="/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/games"
export PATH
STOW_DIR="/usr/local/stow"
export STOW_DIR
GOPATH=~/src/go
export GOPATH
PASSWORD_STORE_DIR=$HOME/.password-store
export PASSWORD_STORE_DIR

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

if [[ $OS = Windows_NT ]]; then
    unset GTAGSLABEL
fi

# Add extra search paths for GTAGS
GTAGSLIBPATH=~/src/navsim/RG5/lib/
export GTAGSLIBPATH

XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Connect to dbus
[[ -z $DBUS_SESSION_BUS_ADDRESS ]] &&
    [[ -e /etc/machine-id ]] &&
    eval $(dbus-launch --sh-syntax --autolaunch $(cat /etc/machine-id))

# Use keychain as a GPG and SSH agent.
eval $(keychain --inherit local-once --quiet --eval 2>/dev/null)

# Start emacs daemon if one isn't already running
pgrep -f "emacs(-gtk|-x11|-w32)? --daemon" &>/dev/null ||
nohup emacs --daemon &> /dev/null &

# Start pulseaudio
which pulseaudio &> /dev/null &&
pulseaudio --start &> /dev/null &

# Workaround multiple gvfsds bug, screwing up mounts in
# /run/user/$UID/gvfs
[[ $(pgrep ^gvfsd$ 2>/dev/null | wc -l) -gt 1 ]] &&
    killall gvfsd &&
    nohup /usr/lib/gvfs/gvfsd &> /dev/null &

# Make sure a dying shell doesn't kill these background processes.
[[ $SHELL = /bin/bash ]] && disown -a
