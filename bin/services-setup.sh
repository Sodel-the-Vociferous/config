#!/bin/bash

sudo systemctl disable lightdm
sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl enable dovecot
sudo systemctl enable gdm
sudo systemctl enable ntpd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
