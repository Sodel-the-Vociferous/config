#!/bin/bash
# Daniel Ralston <Wubbulous@gmail.com>

help () {
    echo "Usage: pacman-install-pkgs.sh [ -h ] PKGLIST-FILE"
    echo "Use to install all uninstalled pacman packages in a list."
}

uninstalled-only () {
    FILE="$1"

    (xargs -a "$FILE" package-query -f "%n" -Qi; cat "$@") |
    sort |
    uniq -u
}

case $1 in
    -h | --h | '')
        help;
        exit 0
esac

FILE="$1"
PKGS=$(uninstalled-only "$FILE") # Get pkgs to install

echo -n "Installing: "
for PNAME in $PKGS; do
    echo -n $PNAME " "
done
echo

if [ -z "$PKGS" ]; then
    echo Nothing to do.
    exit 0
fi

uninstalled-only "$FILE" | sudo xargs pacman -S --noconfirm
