#!/bin/bash

echo /etc/xdg/autostart/gnome-keyring* |
    xargs -n1 ln -sf /dev/null
