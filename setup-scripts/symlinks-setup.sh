#!/bin/bash

LIB_ES_PATH=./lib-ensure-symlinks/lib-ensure-symlinks.sh

if [ ! -e $LIB_ES_PATH ]
then
    echo "ERROR: lib-ensure-symlinks.sh not found at '$LIB_ES_PATH'"
    echo "Run 'git submodule init' first"
    echo
    exit 1
fi

source $LIB_ES_PATH

# Stow
stow --adopt -R -d ~/config/ -t $HOME stow_home
# Copying redshift.conf is a workaround. Redshift can't seem to follow symlinks
# to its config file.
cp --remove-destination -ad ~/config/redshift.conf ~/.config/

# Org-Protocol
(which kbuildsycoca4 || which update-desktop-database) &&
       kbuildsycoca4 &>/dev/null &&
       update-desktop-database ~/.local/share/applications/ &>/dev/null

# "Mounts"
ensure_symlink /media/big-ext ~/media/big-ext

# Directories On My Big Ext Drive
ensure_symlink ~/media/big-ext/$USER/Mail ~/Mail
ensure_symlink ~/media/big-ext/$USER/backups ~/backups
ensure_symlink ~/media/big-ext/$USER/emu ~/emu
ensure_symlink ~/media/big-ext/$USER/lit ~/lit
ensure_symlink ~/media/big-ext/$USER/local-share-Steam ~/.local/share/Steam
ensure_symlink ~/media/big-ext/$USER/music ~/music
ensure_symlink ~/media/big-ext/$USER/steam ~/.steam
ensure_symlink ~/media/big-ext/$USER/vid ~/vid
ensure_symlink ~/media/big-ext/$USER/wine ~/.wine

# DM Directory Aliases
ensure_symlink ~/doc ~/Documents
ensure_symlink ~/tmp ~/Downloads
ensure_symlink ~/music ~/Music
ensure_symlink ~/images ~/Pictures
ensure_symlink ~/vid ~/Videos

