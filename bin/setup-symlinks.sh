#!/bin/bash

confirm_bool () {
    case $1 in
        y|Y)
            return 0;;
        *)
            return 1;;
    esac
}

confirm () {
    msg=$1
    double_confirm=$2

    echo "$msg"
    echo -n "[y/N]? "
    read -r y_or_n

    if [ "$double_confirm" ]
    then
        echo "Are you sure?"
        echo -n "[y/N]? "
        read -r y_or_n2

        # Choice changed?
        [ $(confirm_bool "$y_or_n") -eq $(confirm_bool "$y_or_n2") ] ||
        return 1
    fi

    confirm_bool "$y_or_n"; return $?
}

ensure_symlink () {
    target=$1
    lpath=$2

    # Link already exists, and is pointing at the right place?
    [ -L "$lpath" ] &&
    [ "$(readlink "$lpath")" = "$target" ] &&
    return 0

    if [ ! -e "$target" ]
    then
        echo "ERROR: Skipping '$lpath': link target '$target' does not exist!"
        return 1
    elif [ -d "$lpath" ]
    then
        # Dir exists; delete it?
        confirm "WARNING: '$lpath' is a directory! Link it to '$target'?" \
            "yes" ||
        return 1

        rm -rf "$lpath"
    elif [ -e "$lpath" ]
    then
        # File exists; delete it?
        confirm "WARNING: File '$lpath' exists. Delete it?" ||
        return 1

        rm "$lpath"
    fi

    # Create parent directories for the link if needed
    mkdir -p "$(dirname $lpath)"

    ln -s "$target" "$lpath" &&
    echo Linked "'$lpath'" to "'$target'"
}


## Shell Config

ensure_symlink ~/config/bashrc.sh ~/.bashrc
ensure_symlink ~/config/bash_aliases.sh ~/.bash_aliases
ensure_symlink ~/config/bash_logout.sh ~/.bash_logout
ensure_symlink ~/config/bash_profile.sh ~/.bash_profile
ensure_symlink ~/config/profile.sh ~/.profile

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

# Openbox
ensure_symlink ~/config/openbox/autostart.sh ~/.config/openbox/autostart.sh
ensure_symlink ~/config/openbox/menu.xml ~/.config/openbox/menu.xml
ensure_symlink ~/config/openbox/rc.xml ~/.config/openbox/rc.xml

## Emacs Config

ensure_symlink ~/config/emacs.el ~/.emacs
ensure_symlink ~/config/emacs-site-lisp ~/.emacs.d/site-lisp

## Git Config

ensure_symlink ~/config/gitattributes ~/.gitattributes
ensure_symlink ~/config/gitconfig.conf ~/.gitconfig
ensure_symlink ~/config/gitignore ~/.gitignore
ensure_symlink ~/config/gitignore.global ~/.gitignore.global

## Other Dev Tool Config

ensure_symlink ~/config/pylintrc.conf ~/.pylintrc
ensure_symlink ~/config/sbclrc.lisp ~/.sbclrc

## Other Config

ensure_symlink ~/config/keysnail.js ~/.keysnail.js
ensure_symlink ~/config/mplayer ~/.mplayer/config
ensure_symlink ~/config/nethackrc ~/.nethackrc
ensure_symlink ~/config/newsbeuter.conf ~/.newsbeuter/config
ensure_symlink ~/config/screenrc ~/.screenrc
ensure_symlink ~/config/moc/config ~/.moc/config

# Application Definitions

ensure_symlink ~/config/applications/emacsclient.desktop ~/.local/share/applications/emacsclient.desktop
