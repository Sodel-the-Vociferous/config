#!/bin/bash

sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl disable lightdm
sudo systemctl enable gdm
sudo systemctl enable ntpd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
sudo systemctl enable dovecot
