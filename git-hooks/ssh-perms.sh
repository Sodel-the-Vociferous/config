#!/bin/bash

chmod o-w ~
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

[ -d "$HOME/personal" ] && chmod 700 ~/personal ~/personal/ssh
