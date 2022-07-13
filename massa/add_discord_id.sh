#!/bin/bash

# pkill -9 tmux 
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/add_discord_id.sh)

source .profile

if [ ! $massa_discord_id ]; then
  echo -e "Enter your discord id"
  echo ' '
  read massa_discord_id
fi

cd $HOME/massa/massa-client

massa_wallet_address=$(./massa-client -p $massa_pass wallet_info | grep Address | awk '{ print $2 }')
./massa-client -p $massa_pass node_testnet_rewards_program_ownership_proof $massa_wallet_address $massa_discord_id
