#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/start.sh)

pkill -9 /usr/bin/java
echo 'kill /usr/bin/java'

echo 'restart minima_9001'
systemctl restart minima_9001

echo 'start minima_9003'
systemctl start minima_9003

echo 'start minima_9005'
systemctl start minima_9005

echo 'start minima_9007'
systemctl start minima_9007

echo 'start minima_9009'
systemctl start minima_9009

echo 'start minima_9011'
systemctl start minima_9011

echo 'start minima_9013'
systemctl start minima_9013

echo 'start minima_9015'
systemctl start minima_9015

echo 'start minima_9017'
systemctl start minima_9017

echo 'start minima_9019'
systemctl start minima_9019

echo 'start minima_9021'
systemctl start minima_9021

echo 'start minima_9023'
systemctl start minima_9023

echo 'start minima_9025'
systemctl start minima_9025

echo 'start minima_9027'
systemctl start minima_9027

echo 'start minima_9029'
systemctl start minima_9029

echo 'start minima_9031'
systemctl start minima_9031

echo 'start minima_9033'
systemctl start minima_9033

echo 'start minima_9035'
systemctl start minima_9035

echo 'start minima_9037'
systemctl start minima_9037

echo 'start minima_9039'
systemctl start minima_9039

echo 'start minima_9041'
systemctl start minima_9041

echo DONE
