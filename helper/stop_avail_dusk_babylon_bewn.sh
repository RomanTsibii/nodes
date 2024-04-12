#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/stop_avail_dusk_babylon_bewn.sh)

pkill screen

systemctl stop masa 
systemctl disable masa

docker stop frame

sudo systemctl stop babylon
sudo systemctl disable babylon

docker-compose -f $HOME/rusk/docker-compose.yml down -v

sudo systemctl stop bevmd
sudo systemctl disable bevmd

docker stop boolnetwork
