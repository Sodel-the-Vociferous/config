#!/bin/sh
#
# Executed at session startup

export TMUX=

cd ~;

already_running () {
    pgrep -u $(whoami) ^$@$
    return $?
}

# Desktop wallpaper
WALLPAPER_FILENAME=~/config/wallpaper

already_running syndaemon && killall syndaemon

# Disable touchpad "tap" gestures while typing.
# Idle time: 1.5s; ignore modifier keys
which syndaemon &&
syndaemon -i 1.5 -t -k -d &&
synclient VertTwoFingerScroll=1 \
    PalmDetect=1 \
    TapButton1=1 \
    TapButton2=2 \
    TapButton3=3 \
    PalmMinWidth=10

# already_running numlockx && numlockx # Turn num lock on

xcompmgr &
#already_running tint2 || tint2 &
already_running conky || conky -p 1 --daemonize &
#dropbox stop; dropbox start &

# X keybindings
already_running xbindkeys || xbindkeys
setxkbmap -option ctrl:nocaps

# WM Settings
# wmctrl -n 5 # Workspaces

# Workaround gdm's buggered up placement of .Xauthority
xhost +si:localuser:`id -un`

# already_running xscreensaver || xscreensaver -nosplash &

disown -a
