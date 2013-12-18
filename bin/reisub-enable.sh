#!/bin/bash

echo "kernel.sysrq = 1" | sudo tee /etc/sysctl.d/sysrq.conf
