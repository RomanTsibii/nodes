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

echo 'restart minima_9011'
systemctl restart minima_9011

echo 'restart minima_9013'
systemctl restart minima_9013

echo 'restart minima_9015'
systemctl restart minima_9015

echo 'restart minima_9017'
systemctl restart minima_9017

echo 'restart minima_9019'
systemctl restart minima_9019
echo DONE
