#!/bin/sh
#
# Executed at session startup

already_running () {
    pgrep -u $(whoami) $@
    return $?
}

# Desktop wallpaper
WALLPAPER_FILENAME=~/config/wallpaper
[ -r $WALLPAPER_FILENAME ] && feh --bg-fill $WALLPAPER_FILENAME

# Disable touchpad "tap" gestures while typing.
# Idle time: 1.5s; ignore modifier keys
which syndaemon && syndaemon -i 1.5 -t -k -d &

numlockx & # Turn num lock on

xcompmgr &
tint2 &
conky -p 1 --daemonize &
xscreensaver -no-splash &
dropbox stop; dropbox start &

# X keybindings
xbindkeys
setxkbmap -option ctrl:nocaps

# WM Settings
wmctrl -n 5 # Workspaces
