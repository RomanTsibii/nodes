#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/remove.sh)

sudo systemctl disable initia
sudo systemctl stop initia
rm -rf $HOME/initia
rm -rf $HOME/.initia

sudo systemctl disable initia-oracle
sudo systemctl stop initia-oracle
rm -rf $HOME/initia-oracle
