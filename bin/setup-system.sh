#!/bin/bash
# Setup my system-wide configuration

if [ ! "$(whoami)" = "root" ]
then
    echo "WARNING: This script should probably be run as root."
fi

systemctl enable atd
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
