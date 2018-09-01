#!/bin/bash
#
# Login (i.e. once-per-session) generic shell config.

## Language
LC_COLLATE=C
export LC_COLLATE
# LANG=en_CA.UTF-8
# export LANG

## Environment Variables ##
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/tmp"
XDG_TEMPLATES_DIR="$HOME/templates"
XDG_PUBLICSHARE_DIR="$HOME/public"
XDG_DOCUMENTS_DIR="$HOME/doc/doc"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/images"
XDG_VIDEOS_DIR="$HOME/vid"

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
# Allow default ($PATH-based?) man directories to be searched too, by adding an
# empty field. Fixes `man nix-env``
MANPATH="$MANPATH:"
export MANPATH
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
GTAGSLABEL=default #ctags
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


# Workaround multiple gvfsds bug, screwing up mounts in
# /run/user/$UID/gvfs
[[ $(pgrep ^gvfsd$ 2>/dev/null | wc -l) -gt 1 ]] &&
    killall gvfsd &&
    nohup /usr/lib/gvfs/gvfsd &> /dev/null &

# Make sure a dying shell doesn't kill these background processes.
[[ $SHELL = /bin/bash ]] && disown -a

export PATH="$PATH:$HOME/.cargo/bin:"
