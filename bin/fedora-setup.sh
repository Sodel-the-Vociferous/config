#!/bin/bash
# Setup my system-wide configuration, tailered to Fedora

sudo cp -v --no-preserve=mode,ownership -r ~/config/etc/* /etc

# Enable RPM Fusion repo
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-19.noarch.rpm

sudo yum install $(cat ~/config/pkgs/*.lst) --skip-broken

sudo systemctl enable atd
sudo systemctl enable avahi-daemon
sudo systemctl disable lightdm
sudo systemctl enable gdm
sudo systemctl enable ntpd
sudo systemctl enable remote-fs.target
sudo systemctl enable rpcbind
sudo systemctl enable dovecot
