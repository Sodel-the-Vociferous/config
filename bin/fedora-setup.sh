#!/bin/bash
# Setup my system-wide configuration, tailered to Fedora

sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl enable gdm
sudo systemctl enable ntpd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
sudo systemctl enable sshd
sudo systemctl enable syslog-ng

sudo netctl enable RalstonNet

sudo cp -v --no-preserve=mode,ownership -r ~/config/etc/* /etc
