#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/show_rolls.sh) massa_pass tg_chat_id tg_token
# screen -S massa_balance_evelyday_TG_BOT -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/show_rolls.sh) massa_pass tg_chat_id tg_token"
# 

massa_pass=$1
CHAT_ID=$2
BOT_TOKEN=$3
HOSTNAME=$(hostname -I | awk '{ print $1 }')

function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

source $HOME/.profile
cd $HOME/massa/massa-client

while true
do
  balance=$(./massa-client -p $massa_pass wallet_info | grep "Balance")
  echo $balance
  candidate_rolls=$(./massa-client -p $massa_pass wallet_info | grep "Rolls")
  echo $candidate_rolls
  send_message "*$HOSTNAME*%0A*$balance*%0A*$candidate_rolls*"

  sleep 24h
done
