#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/add_stake_varibles.sh)
if ! grep -q STAKE_SHARDEUM $HOME/.profile; then
        read -p "Set full comand for stake " STAKE_SHARDEUM
        echo 'alias STAKE_SHARDEUM='\'$STAKE_SHARDEUM\' >> $HOME/.profile
        source ~/.profile
fi
