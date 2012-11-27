#!/bin/bash
# Enable my systemd services

if [ ! "$(whoami)" = "root" ]
then
    echo "WARNING: This script should probably be run as root."
fi

systemctl enable avahi-daemon
systemctl enable cronie
systemctl enable net-auto-wired
systemctl enable net-auto-wireless
systemctl enable ntpd
systemctl enable osspd
systemctl enable remote-fs.target
systemctl enable rpcbind
systemctl enable sshd
systemctl enable syslog-ng
