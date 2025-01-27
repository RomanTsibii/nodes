#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/prover_new_account.sh)
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/prover_new_account.sh) address

# логи
# tail -f /root/cysic-prover/logs.log

# restart/start
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/prover_restart_screen.sh)

# stop
# screen -ls | grep cysic | awk '{print $1}' | xargs -I {} screen -S {} -X quit

if [ -n "$1" ]; then
  address="$1"
else
  read -p "Enter your address: " address
fi

SCREEN_NAME=cysic
COMMAND="bash start.sh"
LOG_FILE="$HOME/cysic-prover/logs.log"

cd
bash ~/setup_prover.sh $address
rm -rf cuda-repo*

if screen -list | grep -q "$SCREEN_NAME"; then
  echo "Сесія $SCREEN_NAME вже існує. Закриття..."
  screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

cd ~/cysic-prover/
# Створення скрипта з коректною підстановкою змінної
wget -O "$HOME/cysic-prover/${SCREEN_NAME}_start.sh" https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/restart_always.sh
sed -i "s|COMMAND=\"[^\"]*\"|COMMAND=\"$COMMAND\"|" "${SCREEN_NAME}_start.sh"

chmod u+x "${SCREEN_NAME}_start.sh"

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
