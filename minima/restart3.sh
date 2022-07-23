#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/restart3.sh)

pkill -9 /usr/bin/java
echo 'kill /usr/bin/java'

echo 'restart minima_9021'
systemctl restart minima_9021

echo 'restart minima_9023'
systemctl restart minima_9023

echo 'restart minima_9025'
systemctl restart minima_9025

echo 'restart minima_9027'
systemctl restart minima_9027

echo 'restart minima_9029'
systemctl restart minima_9029
echo DONE
