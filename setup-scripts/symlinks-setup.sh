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


## Shell Config

ensure_symlink ~/config/login-scripts/bashrc.sh ~/.bashrc
ensure_symlink ~/config/login-scripts/bash_aliases.sh ~/.bash_aliases
ensure_symlink ~/config/login-scripts/bash_logout.sh ~/.bash_logout
ensure_symlink ~/config/login-scripts/bash_profile.sh ~/.bash_profile
ensure_symlink ~/config/login-scripts/profile.sh ~/.profile

## Tmux Config
ensure_symlink ~/config/tmux.conf ~/.tmux.conf

## X Config

ensure_symlink ~/config/xbindkeysrc ~/.xbindkeysrc
ensure_symlink ~/config/xinitrc.sh ~/.xinitrc
ensure_symlink ~/config/xsession.sh ~/.xsession
ensure_symlink ~/config/Xdefaults ~/.Xdefaults

ensure_symlink ~/config/conkyrc ~/.conkyrc
ensure_symlink ~/config/terminalrc.conf ~/.config/xfce4/terminal/terminalrc
ensure_symlink ~/config/tint2rc ~/.config/tint2/tint2rc
ensure_symlink ~/config/xscreensaver ~/.xscreensaver

## XFCE Config
ensure_symlink ~/config/xfce/xfconf ~/.config/xfce4/xfconf
ensure_symlink ~/config/xfce/panel ~/.config/xfce4/panel

## Emacs Config

ensure_symlink ~/config/emacs.el ~/.emacs
ensure_symlink ~/config/emacs-site-lisp ~/.emacs.d/site-lisp

## Git Config

ensure_symlink ~/config/gitattributes ~/.gitattributes
ensure_symlink ~/config/gitconfig.conf ~/.gitconfig
ensure_symlink ~/config/gitignore.global ~/.gitignore.global

## Other Dev Tool Config

ensure_symlink ~/config/pylintrc.conf ~/.pylintrc
ensure_symlink ~/config/sbclrc.lisp ~/.sbclrc

## PG Config

ensure_symlink ~/config/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ensure_symlink ~/config/gpg.conf ~/.gnupg/gpg.conf

## Other Config

ensure_symlink ~/config/keysnail.js ~/.keysnail.js
ensure_symlink ~/config/minirc.dfl ~/.minirc.dfl
ensure_symlink ~/config/mplayer ~/.mplayer/config
ensure_symlink ~/config/nethackrc ~/.nethackrc
ensure_symlink ~/config/newsbeuter.conf ~/.newsbeuter/config
ensure_symlink ~/config/screenrc ~/.screenrc
ensure_symlink ~/config/moc/config ~/.moc/config

# Application Definitions

ensure_symlink ~/config/autostart/Xsession.desktop ~/.config/autostart/Xsession.desktop
ensure_symlink ~/config/autostart/Profile.desktop ~/.config/autostart/Profile.desktop
ensure_symlink ~/config/applications/emacsclient.desktop ~/.local/share/applications/emacsclient.desktop
ensure_symlink ~/config/applications/xscreensaver-prefs.desktop ~/.local/share/applications/xscreensaver-prefs

# DM Directory Aliases
ensure_symlink ~/doc ~/Documents
ensure_symlink ~/tmp ~/Downloads
ensure_symlink ~/music ~/Music
ensure_symlink ~/images ~/Pictures
ensure_symlink ~/vid ~/Videos

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
