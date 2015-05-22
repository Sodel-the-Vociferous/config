#!/bin/bash

# Make emacsclient automatically start a daemon if there is none.
ALTERNATE_EDITOR= &&
export ALTERNATE_EDITOR

# Start emacs daemon if one isn't already running
pgrep -f "emacs(-gtk|-x11|-w32)? --daemon" |
nohup emacs --daemon &> /dev/null &

# Start pulseaudio
which pulseaudio &> /dev/null &&
pulseaudio --start &> /dev/null &

unset $DBUS_SESSION_BUS_ADDRESS
eval $(dbus-launch --sh-syntax --autolaunch $(cat /etc/machine-id))

# Make sure a dying shell doesn't kill these background processes.
[[ "$(echo $SHELL | grep /bin/bash)" ]] && disown -a
