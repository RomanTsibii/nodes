#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/stake.sh) PRIV_KEY WALLET_ADDR

# PRIV_KEY=$(dialog --inputbox "Enter your private key from your testnet Shardeum node(Metamask private key) :" 0 0 "" --stdout) && clear
# WALLET_ADDR=$(dialog --inputbox "Enter your wallet address from your testnet Shardeum node(Metamask wallet) :" 0 0 "" --stdout) && clear

if ! grep -q STAKE_SHARDEUM $HOME/.profile; then
        read -p "Set full comand for stake " STAKE_SHARDEUM
        echo 'alias STAKE_SHARDEUM='\'$STAKE_SHARDEUM\' >> $HOME/.profile
        source ~/.profile
fi

PRIV_KEY=$1
WALLET_ADDR=$2

docker exec -it shardeum-dashboard operator-cli start
sleep 40 

# docker exec -it -e PRIV_KEY=$PRIV_KEY shardeum-dashboard operator-cli stake 10
docker exec -d shardeum-dashboard sh -c "(sleep 15; echo '${PRIV_KEY}'; sleep 15) | operator-cli stake 10"
sleep 40 
docker exec -it -e WALLET_ADDR=$WALLET_ADDR shardeum-dashboard operator-cli stake_info $WALLET_ADDR
