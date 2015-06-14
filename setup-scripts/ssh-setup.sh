#!/bin/bash

echo "/etc/ssh/sshd_config" |
xargs -d '\n' readlink -f |
xargs -d '\n' sudo perl -p -i \
    -e 's/^(\s*PasswordAuthentication\s+)yes$/\1 no/gi' \
    "/etc/ssh/sshd_config"

echo "/etc/ssh/sshd_config" |
xargs -d '\n' readlink -f |
xargs -d '\n' sudo perl -p -i \
    -e 's/^(\s*ChallengeResponseAuthentication\s+)yes$/\1 no/gi' \
    "/etc/ssh/sshd_config"

