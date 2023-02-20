#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/show_rolls.sh)

source $HOME/.profile
cd $HOME/massa/massa-client
balance=$(./massa-client --pwd $massa_pass wallet_info | grep "Balance" |)
echo $balance
candidate_rolls=$(./massa-client --pwd $massa_pass wallet_info | grep "Rolls")
echo $candidate_rolls
