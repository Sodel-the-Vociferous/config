#!/bin/bash

if [[ $UID -ne 0 ]]
then
   echo Please run this script as root.
fi

mv /usr/share/pulseaudio/alsa-mixer/paths/analog-output-headphones.conf /usr/share/pulseaudio/alsa-mixer/paths/analog-output-headphones.conf.backup
touch /usr/share/pulseaudio/alsa-mixer/paths/analog-output-headphones.conf
