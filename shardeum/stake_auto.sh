#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/stake_auto.sh)

if [ -z $STAKE_SHARDEUM ]; then
        read -p "Set full comand for stake " STAKE_SHARDEUM
        echo 'alias STAKE_SHARDEUM='"$STAKE_SHARDEUM" >> $HOME/.profile
        source ~/.profile
fi

STAKE_SHARDEUM
