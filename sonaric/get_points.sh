#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/sonaric/get_points.sh)
sonaric points &> /dev/null
if ! command -v screen &> /dev/null; then
    sudo apt update && sudo apt install screen -y 2>&1
fi

SESSION_NAME="sonaric_get_points"
LOG_FILE="/var/log/sonaric.log"

# Запуск нової сесії
screen -dmS "$SESSION_NAME"
sleep 1
# добавити файл логування
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on
# Виконання команди в новій сесії
screen -S "$SESSION_NAME" -X stuff "sonaric points"
# sleep 3
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
sleep 4

screen -wipe > /dev/null 2>&1
screen -list | grep -q "$SESSION_NAME" && screen -S "$SESSION_NAME" -X quit

tail -3 $LOG_FILE | grep Points | awk '{print $NF}'
