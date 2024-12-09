#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/screen_install.sh) prover_id



if [ -n "$1" ]; then
  prover_id="$1"
else
  read -p "Enter your prover id: " prover_id
fi


SESSION_NAME="nexus"
LOG_FILE="/var/log/nexus.log"

# Запуск нової сесії
screen -dmS "$SESSION_NAME"
sleep 1
# добавити файл логування
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on
# Виконання команди в новій сесії
screen -S "$SESSION_NAME" -X stuff "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/install.sh)"
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
sleep 10

screen -S "$SESSION_NAME" -X stuff "$prover_id" # натискання Enter
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter

# screen -wipe > /dev/null 2>&1
# screen -list | grep -q "$SESSION_NAME" && screen -S "$SESSION_NAME" -X quit

# tail -3 $LOG_FILE | grep Points | awk '{print $NF}'
