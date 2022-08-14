#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/sui/wallet_and_IP.sh)

source $HOME/.profile

echo "http://`wget -qO- eth0.me`:9000/"
sui keytool list
