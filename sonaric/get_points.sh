#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/sonaric/get_points.sh)

sudo apt install screen -y
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
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
sleep 1

cat $LOG_FILE | tail -3 | grep Points | sed -E 's/.*Points: ([0-9.]+)/\1/'
