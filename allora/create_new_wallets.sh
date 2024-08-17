#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/create_new_wallets.sh) pass 
# screen -S allora_allora -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/create_new_wallets.sh) pass" 

pass=$1

SESSION_NAME="allora_keys_new"
LOG_FILE="/var/log/allora_keys_new.log"

screen -dmS "$SESSION_NAME"
sleep 1
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on

for ((i=1; i<=10; i+=1)); do  # echo $i  ; done
  # Виконання команди в новій сесії
  screen -S "$SESSION_NAME" -X stuff "source ~/.profile && allorad keys add testkey"
  sleep 1
  screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
  sleep 3
  screen -S "$SESSION_NAME" -X stuff "$pass"
  sleep 1
  screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
  sleep 1
  screen -S "$SESSION_NAME" -X stuff "Y"
  sleep 1
  screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
  sleep 2
  # echo "cat $LOG_FILE"
  
  seed=$(cat $LOG_FILE | grep password -2 | tail -1)
  address=$(cat $LOG_FILE | grep address | awk '{print $3}')
  
  echo "------------------"
  echo $seed
  echo $address
  rm /var/log/allora_keys_new.log
done
