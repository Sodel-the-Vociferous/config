#!/bin/bash
# Written by Daniel Ralston
#
# Usage: position-conky.sh <conky-conf>

if [ ! "$1" ];
then
    echo Usage: position-conky.sh CONKY-CONF
    exit 1
fi

CONKY_MARGIN_X=7
CONKY_MARGIN_Y=20

CONKYRC=$1
CONKY_WIDTH=$(perl -ne "s/.*maximum_width\s+(\d+).*$/\1/ and print" $CONKYRC)
DISPLAY_WIDTH=$(wmctrl -d |
    head -n1 |
    cut -d ' ' -f5 |
    perl -ne "s/^(\d*?)x.+$/\1/ and print")
NEW_CONKY_GAP_X=$(expr $DISPLAY_WIDTH - $CONKY_WIDTH)
NEW_CONKY_GAP_X=$(expr $NEW_CONKY_GAP_X - $CONKY_MARGIN_X)

echo DISP: $DISPLAY_WIDTH C: $CONKY_WIDTH NEW: $NEW_CONKY_GAP_X

sed --follow-symlinks -r -i -e "s/gap_x.*/\gap_x $NEW_CONKY_GAP_X/g" $CONKYRC
sed --follow-symlinks -r -i -e "s/gap_y.*/\gap_y $CONKY_MARGIN_Y/g" $CONKYRC
