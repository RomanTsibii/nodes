#!/bin/bash

# запустити автопокупку
# tmux new-session -d -s massa_send_to_main_account 'bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/send_to_main_account.sh) massa_password massa_node_address'

# зупинити автопокупку
# tmux kill-session -t massa_send_to_main_account 

# глянути логи 
# tmux attach-session -t massa_send_to_main_account
# Ctrl+B і потім D - це щоб вийти з логів

massa_pass=$1
massa_node_address=$2
source $HOME/.profile

cd $HOME/massa/massa-client

# massa_wallet_addresses=$(./massa-client -p $massa_pass wallet_info | grep Address | awk '{ print $2 }') 

massa_wallet_addresses=()
while IFS= read -r address; do
    massa_wallet_addresses+=("$address")  # Додаємо кожен рядок до масиву
done < <(./massa-client -p "$massa_pass" wallet_info | grep Address | awk '{ print $2 }')

# видалити з масиву адрес massa_node_address
massa_wallet_addresses=("${massa_wallet_addresses[@]/$massa_node_address}")

function send_tokens {
    echo "$addr"
    # send_transaction SenderAddress ReceiverAddress Amount Fee: send coins from a wallet address
    tx_trans=$(./massa-client -p $massa_pass send_transaction $addr $massa_node_address $int_balance 0)
    echo $tx_trans
}

# цикл вічний з очікуванням
while true
do
  # цикл на перерахування всіх адрес 
  for addr in "${massa_wallet_addresses[@]}"; do
      # if [[ ! -z "$address" ]] ; then
          balance=$(./massa-client -p $massa_pass wallet_info | grep $addr -A 3 | grep "Balance" | awk '{ print $3 }' | sed 's/candidate=//;s/,//')
          int_balance=${balance%%.*}
          
          # якщо баланс більше 1 то скинути монети на massa_node_address
          if [ "$int_balance" -gt 1 ]; then send_tokens  ; fi
          
          # очікувати 10
          sleep 10
      # fi
  done
  echo "sleep 12h"
  sleep 12h
done
