#!/bin/bash
# Prevent GDM from starting pulseaudio, which is annoying.

echo "This script should be run as root."

gconftool-2 –direct –config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory –type Boolean –set /apps/gdm/simple-greeter/settings-manager-plugins/sound/active False

cat >> /var/lib/gdm/.pulse/client.conf << EOF
autospawn = no
daemon-binary = /bin/true
EOF

chown gdm:gdm /var/lib/gdm/.pulse/client.conf
