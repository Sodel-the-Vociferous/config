#!/bin/bash

function do () {
    find $DIR -iname "libstd*.so*" -print -delete
    find $DIR -iname "libgcc*.so*" -print -delete
    find $DIR -iname "libxcb*.so*" -print -delete
}

DIR=$HOME/.local/share/Steam/ do
DIR=$HOME/ubuntu12_32/steam-runtime do
echo "All Done"
