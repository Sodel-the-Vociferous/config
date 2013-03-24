## Shell Config

file { "/home/${id}/.bashrc":
  ensure => link,
  target => "/home/${id}/config/bashrc.sh"
}
file { "/home/${id}/.bash_aliases":
  ensure => link,
  target => "/home/${id}/config/bash_aliases.sh"
}
file { "/home/${id}/.bash_logout":
  ensure => link,
  target => "/home/${id}/config/bash_logout.sh"
}
file { "/home/${id}/.bash_profile":
  ensure => link,
  target => "/home/${id}/config/bash_profile.sh"
}
file { "/home/${id}/.profile":
  ensure => link,
  target => "/home/${id}/config/profile.sh"
}

## X Config

file { "/home/${id}/.xbindkeysrc":
  ensure => link,
  target => "/home/${id}/config/xbindkeysrc"
}
file { "/home/${id}/.xinitrc":
  ensure => link,
  target => "/home/${id}/config/xinitrc.sh"
}
file { "/home/${id}/.xsession":
  ensure => link,
  target => "/home/${id}/config/xsession.sh"
}
file { "/home/${id}/.Xdefaults":
  ensure => link,
  target => "/home/${id}/config/Xdefaults"
}

file { "/home/${id}/.conkyrc":
  ensure => link,
  target => "/home/${id}/config/conkyrc"
}
file { "/home/${id}/.config/Terminal/terminalrc":
  ensure => link,
  target => "/home/${id}/config/terminalrc.conf"
}
file { "/home/${id}/.config/tint2/tint2rc":
  ensure => link,
  target => "/home/${id}/config/tint2rc"
}

# Openbox
file { "/home/${id}/.config/openbox/autostart.sh":
  ensure => link,
  target => "/home/${id}/config/openbox/autostart.sh"
}
file { "/home/${id}/.config/openbox/menu.xml":
  ensure => link,
  target => "/home/${id}/config/openbox/menu.xml"
}
file { "/home/${id}/.config/openbox/rc.xml":
  ensure => link,
  target => "/home/${id}/config/openbox/rc.xml"
}

## Emacs Config

file { "/home/${id}/.emacs":
  ensure => link,
  target => "/home/${id}/config/emacs.el"
}
file { "/home/${id}/.emacs.d/site-lisp":
  ensure => link,
  target => "/home/${id}/config/emacs-site-lisp"
}

## Git Config

file { "/home/${id}/.gitattributes":
  ensure => link,
  target => "/home/${id}/config/gitattributes"
}
file { "/home/${id}/.gitconfig":
  ensure => link,
  target => "/home/${id}/config/gitconfig.conf"
}
file { "/home/${id}/.gitignore":
  ensure => link,
  target => "/home/${id}/config/gitignore"
}
file { "/home/${id}/.gitignore.global":
  ensure => link,
  target => "/home/${id}/config/gitignore.global"
}

## Other Dev Tool Config

file { "/home/${id}/.pylintrc":
  ensure => link,
  target => "/home/${id}/config/pylintrc.conf"
}
file { "/home/${id}/.sbclrc":
  ensure => link,
  target => "/home/${id}/config/sbclrc.lisp"
}

## Other Config

file { "/home/${id}/.keysnail.js":
  ensure => link,
  target => "/home/${id}/config/keysnail.js"
}
file { "/home/${id}/.mplayer/config":
  ensure => link,
  target => "/home/${id}/config/mplayer"
}
file { "/home/${id}/.nethackrc":
  ensure => link,
  target => "/home/${id}/config/nethackrc"
}
file { "/home/${id}/.newsbeuter/config":
  ensure => link,
  target => "/home/${id}/config/newsbeuter.conf"
}
file { "/home/${id}/.screenrc":
  ensure => link,
  target => "/home/${id}/config/screenrc"
}
file { "/home/${id}/.moc":
  ensure => directory
}
file { "/home/${id}/.moc/config":
  ensure => link,
  target => "/home/${id}/config/moc/config"
}

# Application Definitions

file { "/home/${id}/.local/share/applications/emacsclient.desktop":
  ensure => link,
  target => "/home/${id}/config/applications/emacsclient.desktop"
}
