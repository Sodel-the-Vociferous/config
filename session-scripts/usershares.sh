#!/bin/bash

net usershare add $USER-prj $HOME/prj/ "" Everyone:f
net usershare add $USER-obj $HOME/obj/ "" Everyone:f
net usershare add $USER-share $HOME/share/ "" Everyone:f
net usershare add $USER-fea /mnt/big-ext/$USER/fea/ "" Everyone:f
