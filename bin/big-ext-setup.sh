#!/bin/bash

if [ $UID != 0 ]
then
    echo "Run this script as root."
    exit 1
fi

mkdir /media/big-ext
echo "/dev/disk/by-label/BigExt /media/big-ext              ext4    defaults        0 0" | tee -a /etc/fstab
