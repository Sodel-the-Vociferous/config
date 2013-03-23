#!/bin/bash

NUM_WS=$(wmctrl -d | wc -l)
MIN_WS=0
MAX_WS=$(expr $NUM_WS - 1)
CUR_WS=$(wmctrl -d | perl -n -e "s/^(\d+)\s+\*\s+.*/\1/ and print")

case $1 in
    RIGHT)
        NEW_WS=$(expr $CUR_WS + 1);;
    LEFT)
        NEW_WS=$(expr $CUR_WS - 1);;
esac

case $NEW_WS in
    $NUM_WS)
        NEW_WS=$MIN_WS;;
    -1)
        NEW_WS=$MAX_WS;;
esac

echo $CUR_WS "->" $NEW_WS

wmctrl -r :ACTIVE: -t $NEW_WS
wmctrl -s $NEW_WS
