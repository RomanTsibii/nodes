#!/bin/bash

# pkill -9 tmux 
# запустити автопокупку
# tmux new-session -d -s massa_buy_rolls_mainnet 'bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/autobuy_rolls_mainet.sh) massa_password'

# зупинити автопокупку
# tmux kill-session -t massa_buy_rolls_mainnet 

# глянути логи 
# tmux attach-session -t massa_buy_rolls_mainnet
# Ctrl+B і потім D - це щоб вийти з логів

massa_pass=$1
source $HOME/.profile

cd $HOME/massa/massa-client
massa_wallet_address=$(./massa-client -p $massa_pass wallet_info | grep Address | awk '{ print $2 }')

# Telegram send message
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

# запуск покупки ролів
while true
do
  balance=$(./massa-client -p $massa_pass wallet_info | grep "Balance" | awk '{ print $3 }' | sed 's/candidate=//;s/,//')
  int_balance=${balance%%.*}
  if [ $int_balance -gt "99" ] ; then   
    resp=$(./massa-client -p $massa_pass buy_rolls $massa_wallet_address 1 0)
    echo "buy rolls"
    if [[ ! -z $BOT_TOKEN && $CHAT_ID ]]; then   
        send_message "Buy 100 rolls. Server IP *$HOSTNAME*"
    fi
  else
    echo "Less than 100"
  fi
  printf "sleep"
  for((sec=0; sec<60; sec++))
  do
    printf "."
    sleep 1
  done
  printf "\n"
done
