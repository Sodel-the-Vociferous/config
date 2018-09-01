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

ensure_symlink ~/config/session-scripts/bashrc.sh ~/.bashrc
ensure_symlink ~/config/session-scripts/bash_aliases.sh ~/.bash_aliases
ensure_symlink ~/config/session-scripts/bash_logout.sh ~/.bash_logout
ensure_symlink ~/config/session-scripts/bash_profile.sh ~/.bash_profile
ensure_symlink ~/config/session-scripts/profile.sh ~/.profile
ensure_symlink ~/config/inputrc ~/.inputrc

## Tmux Config
ensure_symlink ~/config/tmux.conf ~/.tmux.conf

## X Config

ensure_symlink ~/config/xbindkeysrc ~/.xbindkeysrc
ensure_symlink ~/config/Xdefaults ~/.Xdefaults
ensure_symlink ~/config/session-scripts/xsession.sh ~/.xsession

ensure_symlink ~/config/conkyrc ~/.conkyrc
ensure_symlink ~/config/terminalrc.conf ~/.config/xfce4/terminal/terminalrc
ensure_symlink ~/config/tint2rc ~/.config/tint2/tint2rc
ensure_symlink ~/config/xscreensaver ~/.xscreensaver

## XFCE Config
ensure_symlink ~/config/xfce/xfconf ~/.config/xfce4/xfconf
ensure_symlink ~/config/xfce/panel ~/.config/xfce4/panel

## KDE Config
ensure_symlink ~/config/kde/kdeglobals ~/.config/kdeglobals
ensure_symlink ~/config/kde/kglobalshortcutsrc ~/.config/kglobalshortcutsrc
ensure_symlink ~/config/kde/ksplashrc ~/.config/ksplashrc
ensure_symlink ~/config/kde/ktimezonedrc ~/.config/ktimezonedrc
ensure_symlink ~/config/kde/kwinrc ~/.config/kwinrc
ensure_symlink ~/config/kde/plasmarc ~/.config/plasmarc

ensure_symlink ~/config/konsole/konsolerc ~/.kde4/share/config/konsolerc
ensure_symlink ~/config/konsole/Shell.profile ~/.kde4/share/apps/konsole/Shell.profile
ensure_symlink ~/config/konsole/WhiteOnBlack.colorscheme ~/.kde4/share/apps/konsole/WhiteOnBlack.colorscheme
ensure_symlink ~/config/konquerorrc ~/.kde4/share/config/konquerorrc

## Git Config

ensure_symlink ~/config/gitattributes ~/.gitattributes
ensure_symlink ~/config/gitconfig.conf ~/.gitconfig
ensure_symlink ~/config/gitignore.global ~/.gitignore.global

## Other Dev Tool Config

ensure_symlink ~/config/globalrc ~/.globalrc
ensure_symlink ~/config/pylintrc.conf ~/.pylintrc
ensure_symlink ~/config/sbclrc.lisp ~/.sbclrc

## PG Config

ensure_symlink ~/config/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ensure_symlink ~/config/gpg.conf ~/.gnupg/gpg.conf

## Other Config

ensure_symlink ~/config/LibreCAD.conf ~/.config/LibreCAD/LibreCAD.conf
ensure_symlink ~/config/keysnail.js ~/.keysnail.js
ensure_symlink ~/config/minirc.dfl ~/.minirc.dfl
ensure_symlink ~/config/srhk-prefs.xml ~/.config/unity3d/Harebrained\ Schemes/SRHK/prefs
ensure_symlink ~/config/nethackrc ~/.nethackrc
ensure_symlink ~/config/newsbeuter.conf ~/.newsbeuter/config
ensure_symlink ~/config/prboom-plus.cfg ~/.prboom-plus/prboom-plus.cfg
ensure_symlink ~/config/redshift.conf ~/.config/redshift.conf
ensure_symlink ~/config/screenrc ~/.screenrc
ensure_symlink ~/config/moc/config ~/.moc/config
ensure_symlink ~/config/zdoom.ini ~/.config/zdoom/zdoom.ini

## SystemD Services Config
ensure_symlink ~/config/systemd-services/emacs.service ~/.config/systemd/user/emacs.service
ensure_symlink ~/config/systemd-services/dirmngr.service ~/.config/systemd/user/dirmngr.service
ensure_symlink ~/config/systemd-services/dirmngr.socket ~/.config/systemd/user/dirmngr.socket
ensure_symlink ~/config/systemd-services/gpg-agent-browser.socket ~/.config/systemd/user/gpg-agent-browser.socket
ensure_symlink ~/config/systemd-services/gpg-agent-extra.socket ~/.config/systemd/user/gpg-agent-extra.socket
ensure_symlink ~/config/systemd-services/gpg-agent-ssh.socket ~/.config/systemd/user/gpg-agent-ssh.socket
ensure_symlink ~/config/systemd-services/gpg-agent.service ~/.config/systemd/user/gpg-agent.service
ensure_symlink ~/config/systemd-services/gpg-agent.socket ~/.config/systemd/user/gpg-agent.socket
ensure_symlink ~/config/systemd-services/ssh-agent.service ~/.config/systemd/user/ssh-agent.service

(which kbuildsycoca4 || which update-desktop-database) &&
    ensure_symlink \
        ~/config/applications/org-protocol.desktop \
        ~/.local/share/applications/org-protocol.desktop &&
    kbuildsycoca4 &>/dev/null &&
    update-desktop-database ~/.local/share/applications/ &>/dev/null

# Application Definitions

ensure_symlink ~/config/autostart/Xsession.desktop ~/.config/autostart/Xsession.desktop
ensure_symlink ~/config/autostart/Profile.desktop ~/.config/autostart/Profile.desktop
ensure_symlink ~/config/applications/Simplify3D.desktop ~/.local/share/applications/Simplify3D.desktop
ensure_symlink ~/config/applications/emacsclient.desktop ~/.local/share/applications/emacsclient.desktop
ensure_symlink ~/config/applications/xscreensaver-prefs.desktop ~/.local/share/applications/xscreensaver-prefs

# DM Directory Aliases
ensure_symlink ~/doc ~/Documents
ensure_symlink ~/tmp ~/Downloads
ensure_symlink ~/music ~/Music
ensure_symlink ~/images ~/Pictures
ensure_symlink ~/vid ~/Videos

# "Mounts"
ensure_symlink /mnt/big-ext/ ~/mnt/big-ext

# Directories On My Big Ext Drive
ensure_symlink ~/mnt/big-ext/$USER/Mail ~/Mail
ensure_symlink ~/mnt/big-ext/$USER/backups ~/backups
ensure_symlink ~/mnt/big-ext/$USER/emu ~/emu
ensure_symlink ~/mnt/big-ext/$USER/lit ~/lit
ensure_symlink ~/mnt/big-ext/$USER/local-share-Steam ~/.local/share/Steam
ensure_symlink ~/mnt/big-ext/$USER/music ~/music
ensure_symlink ~/mnt/big-ext/$USER/steam ~/.steam
ensure_symlink ~/mnt/big-ext/$USER/vid ~/vid
ensure_symlink ~/mnt/big-ext/$USER/wine ~/.wine
