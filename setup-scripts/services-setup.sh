#!/bin/bash

systemctl --user enable $HOME/config/systemd-services/emacsd.service
systemctl --user enable $HOME/config/systemd-services/keychain.service
