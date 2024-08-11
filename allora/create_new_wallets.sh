#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/create_new_wallets.sh) pass 
# screen -S allora_allora -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/create_new_wallets.sh) pass" 

pass=$1

SESSION_NAME="allora_keys_new"
LOG_FILE="/var/log/allora_keys_new.log"

# Запуск нової сесії
screen -dmS "$SESSION_NAME"
sleep 1
# добавити файл логування
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on
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

echo "cat /var/log/allora_keys.log"
