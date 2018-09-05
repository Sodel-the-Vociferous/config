#!/bin/bash

systemctl --user enable emacs.service
systemctl --user enable gpg-agent.socket
systemctl --user enable redshift-gtk.socket
systemctl --user enable ssh-agent.service
systemctl --user enable syncthing.service
