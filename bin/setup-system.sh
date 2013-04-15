#!/bin/bash
# Setup my system-wide configuration

sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl enable cronie
sudo systemctl enable netctl
sudo systemctl enable netctl-ifplugd
sudo systemctl enable ntpd
sudo systemctl enable osspd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
sudo systemctl enable sshd
sudo systemctl enable syslog-ng

sudo netctl enable RalstonNet

sudo cp -vr ~/config/etc/* /etc
