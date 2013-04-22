#!/bin/bash
#
# Login (i.e. once-per-session) generic shell config.

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
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH

# Make Wine emulate 32-bit Windows.
WINEARCH=win32
export WINEARCH

# Prevent Python from cluttering my filesystem up with .pyc files
PYTHONDONTWRITEBYTECODE=true
export PYTHONDONTWRITEBYTECODE


## Start Programs/Daemons

# Use keychain as an ssh agent only, sending debug output to /dev/null
# instead of barfing on the login shell. (Only do this if there isn't
# already an SSH Agent accessible.)
[ "$SSH_AGENT" ] || eval $(keychain --eval --agents ssh,gpg 2> /dev/null)

# Start emacs
[ -e /tmp/emacs$(id -u)/server ] || nohup emacs --daemon &> /dev/null &

# Start dropbox
nohup dropbox start &> /dev/null &

[[ $SHELL = /bin/bash ]] && disown -a
