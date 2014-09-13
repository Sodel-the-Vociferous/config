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

# Directories On My Big Ext Drive
ensure_symlink /media/big-ext/dralston/Mail ~/Mail
ensure_symlink /media/big-ext/dralston/backups ~/backups
ensure_symlink /media/big-ext/dralston/emu ~/emu
ensure_symlink /media/big-ext/dralston/lit ~/lit
ensure_symlink /media/big-ext/dralston/local-share-Steam ~/.local/share/Steam
ensure_symlink /media/big-ext/dralston/music ~/music
ensure_symlink /media/big-ext/dralston/steam ~/.steam
ensure_symlink /media/big-ext/dralston/vid ~/vid
ensure_symlink /media/big-ext/dralston/wine ~/.wine
