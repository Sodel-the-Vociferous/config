#!/bin/bash

source ~/.profile
echo $DBUS_SESSION_BUS_ADDRESS
exec emacs-x11 --daemon
