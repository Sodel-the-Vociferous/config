#!/bin/bash
#
# Executed at session startup

export TMUX=

cd ~;

# Desktop wallpaper
WALLPAPER_FILENAME=~/config/wallpaper

# Disable touchpad "tap" gestures while typing.
# Idle time: 1.5s; ignore modifier keys
# systemd-run --user --unit=syndaemon.service \
#             syndaemon -i 1.5 -t -k -d
# systemd-run --user -p After=syndaemon.service --unit=synclient.service \
#             synclient VertTwoFingerScroll=1 \
#             PalmDetect=1 \
#             TapButton1=1 \
#             TapButton2=2 \
#             TapButton3=3 \
#             PalmMinWidth=10

# X keybindings
systemctl --user start xbindkeys &
systemctl --user start conky &
systemctl --user start syncthing-gtk &
setxkbmap -option ctrl:nocaps

# Workaround gdm's buggered up placement of .Xauthority
xhost +si:localuser:`id -un`

disown -a
