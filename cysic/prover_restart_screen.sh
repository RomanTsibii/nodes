#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/prover_restart_screen.sh)
# 
# логи
# tail -f /root/cysic-prover/logs.log

SCREEN_NAME=cysic
LOG_FILE="$HOME/cysic-prover/logs.log"

if screen -list | grep -q "$SCREEN_NAME"; then
  echo "Сесія $SCREEN_NAME вже існує. Закриття..."
  screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

cd ~/cysic-prover/
# 2 запустити у ньому у фоні файл
sleep 1
echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X logfile "$LOG_FILE"
screen -S "$SCREEN_NAME" -X log on
sleep 1
screen -S "$SCREEN_NAME" -X stuff "bash ${SCREEN_NAME}_start.sh"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter

echo "DONE"
echo "Logs: tail -f /root/cysic-prover/logs.log"
