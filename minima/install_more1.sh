#!/bin/sh
# https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/install_more1.sh
# sudo kill -9 `sudo lsof -t -i:9001`

systemctl stop minima_90*
systemctl disable minima_9010


rm -rf /home/minima/.minima*

