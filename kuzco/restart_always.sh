#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kuzco/restart_always.sh) kuzco


if [ -n "$1" ]; then
  SCREEN_NAME="$1"
else
  read -p "Enter your SCREEN_NAME: " SCREEN_NAME
fi

# Перевірка аргумента командного рядка
if [ -n "$2" ]; then
  COMMAND="$2"
else
  read -p "Enter your COMMAND: " COMMAND
fi

if screen -list | grep -q "$SCREEN_NAME"; then
  echo "Сесія $SCREEN_NAME вже існує. Закриття..."
  screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

# Створення скрипта з коректною підстановкою змінної
wget -O "$HOME/${SCREEN_NAME}_start.sh" https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/restart_always.sh
sed -i "s|COMMAND=\"[^\"]*\"|COMMAND=\"$COMMAND\"|" "$HOME/${SCREEN_NAME}_start.sh"

chmod u+x "$HOME/${SCREEN_NAME}_start.sh"

# 2 запустити у ньому у фоні файл

sleep 1
echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X colon "logfile flush 0^M"  
sleep 1
screen -S "$SCREEN_NAME" -X stuff "bash $HOME/${SCREEN_NAME}_start.sh"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter
