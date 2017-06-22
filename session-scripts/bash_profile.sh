#!/bin/bash

if (uname -r | egrep -e "Microsoft$" &> /dev/null) && [[ -z "$DISPLAY" ]]; then
   export DISPLAY=":0.0"
   xset -q &> /dev/null || unset DISPLAY
fi

. $HOME/.profile
. $HOME/.bashrc
if [ -e /home/dralston/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dralston/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
