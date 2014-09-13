#!/bin/bash

if [ $UID != 0 ]
then
    echo "Run this script as root."
    exit 1
fi

FSTAB_LINE = "/dev/disk/by-label/BigExt /media/big-ext              ext4    defaults,auto   0 0"

mkdir -p /media/big-ext

grep -ve "$FSTAB_LINE" ||
echo "$FSTAB_LINE" |
tee -a /etc/fstab
