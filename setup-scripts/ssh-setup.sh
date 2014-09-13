#!/bin/bash

echo "/etc/ssh/sshd_config" |
xargs -d '\n' readlink -f |
xargs -d '\n' sudo perl -p -i \
    -e 's/^(\s*PasswordAuthentication\s+yes)$/#\1/gi' \
    "/etc/ssh/sshd_config"

sudo ack "^\s*PasswordAuthentication\s+no" /etc/ssh/sshd_config >/dev/null ||
( echo -e "\nPasswordAuthentication no" |
    sudo tee -a "/etc/ssh/sshd_config" )
