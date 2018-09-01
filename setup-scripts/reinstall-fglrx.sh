#!/bin/bash

zypper in -f $(zypper se fglrx | tail -n +6 | cut -d '|' -f2)
