#!/bin/bash
# Setup my system-wide configuration

sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl enable cronie
sudo systemctl enable net-auto-wired
sudo systemctl enable net-auto-wireless
sudo systemctl enable ntpd
sudo systemctl enable osspd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
sudo systemctl enable sshd
sudo systemctl enable syslog-ng

sudo cp -vr ~/config/etc/* /etc
