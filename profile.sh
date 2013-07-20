#!/bin/bash
#
# Login (i.e. once-per-session) generic shell config.

## Language
LC_COLLATE=C
export LC_COLLATE
LANG=en_CA.UTF-8
export LANG

## Environment Variables ##
EDITOR=emacsclient
export EDITOR
VISUAL=$EDITOR
export VISUAL
ALTERNATE_EDITOR=
export ALTERNATE_EDITOR

# Set up paths
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/lib32/usr/lib/:/usr/local/lib"
export LD_LIBRARY_PATH
GTK_PATH=/opt/lib32/usr/lib/gtk-2.0/
export GTK_PATH
PANGO_RC_FILE="/opt/lib32/config/pango/pangorc"
export PANGO_RC_FILE
GCONV_PATH=/opt/lib32/usr/lib/gconv
export GCONV_PATH
GDK_PIXBUF_MODULE_FILE="/opt/lib32/config/gdk/gdk-pixbuf.loaders"
export GDK_PIXBUF_MODULE_FILE
PATH="/usr/local/bin:/usr/local/sbin:$PATH:/usr/local/games"
export PATH
STOW_DIR="/usr/local/stow"
export STOW_DIR

# Make Wine emulate 32-bit Windows.
WINEARCH=win32
export WINEARCH

# Prevent Python from cluttering my filesystem up with .pyc files
PYTHONDONTWRITEBYTECODE=true
export PYTHONDONTWRITEBYTECODE


## Start Programs/Daemons

# Use keychain as a GPG and SSH agent, sending debug output to
# /dev/null instead of barfing on the login shell. (Only do this if
# there isn't already a GPG/SSH Agent accessible.)
[ "$SSH_AGENT" ] || eval $(keychain --eval --agents ssh,gpg 2> /dev/null)

# Start emacs daemon if one isn't already running
pgrep ^emacs$ |
xargs --no-run-if-empty ps -fp |
tail -n +2 |
grep -e --daemon > /dev/null ||
nohup emacs --daemon &> /dev/null &

# Start dropbox
#nohup dropbox start &> /dev/null &

[[ "$(echo $SHELL | grep /bin/bash)" ]] && disown -a
