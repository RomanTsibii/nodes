#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/restart.sh)

pkill -9 /usr/bin/java
echo 'kill /usr/bin/java'

echo 'restart minima_9001'
systemctl restart minima_9001

echo 'restart minima_9003'
systemctl restart minima_9003

echo 'restart minima_9005'
systemctl restart minima_9005

echo 'restart minima_9007'
systemctl restart minima_9007

echo 'restart minima_9009'
systemctl restart minima_9009
echo DONE
