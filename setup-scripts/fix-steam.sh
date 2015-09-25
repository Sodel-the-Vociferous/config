#!/bin/bash
DIR=$HOME/.local/share/Steam/

find $DIR -iname "libstd*" -delete
find $DIR -iname "libgcc*" -delete
find $DIR -iname "libxcb*" -delete

echo "All Done"
