#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/stop.sh)

pkill -9 /usr/bin/java
echo 'kill /usr/bin/java'

echo 'restart minima_9001'
systemctl restart minima_9001

echo 'stop minima_9003'
systemctl stop minima_9003

echo 'stop minima_9005'
systemctl stop minima_9005

echo 'stop minima_9007'
systemctl stop minima_9007

echo 'stop minima_9009'
systemctl stop minima_9009

echo 'stop minima_9011'
systemctl stop minima_9011

echo 'stop minima_9013'
systemctl stop minima_9013

echo 'stop minima_9015'
systemctl stop minima_9015

echo 'stop minima_9017'
systemctl stop minima_9017

echo 'stop minima_9019'
systemctl stop minima_9019

echo 'stop minima_9021'
systemctl stop minima_9021

echo 'stop minima_9023'
systemctl stop minima_9023
echo DONE
