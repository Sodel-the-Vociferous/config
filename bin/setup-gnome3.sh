#!/bin/bash

# Desktop background
BACKGROUND_REAL_PATH=$(readlink -f ~/config/background)
gsettings set org.gnome.desktop.background picture-uri "file://$BACKGROUND_REAL_PATH"

# Stop GNOME from overwriting my synclient settings after the system
# resumes from suspension
which synclient &&
gsettings set org.gnome.settings-daemon.plugins.mouse active false
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action blank
