#!/bin/bash

chmod o-w ~
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/config

[ -d "$HOME/personal" ] && chmod 700 ~/personal/ssh
