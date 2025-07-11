#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/restart.sh)

SCREEN_NAME=gensyn
LOG_FILE="/root/rl-swarm/logs.log"

# зупинити сесія якщо вже існує
if screen -list | grep -q "\.${SCREEN_NAME}"; then
   screen -wipe
   screen -S "$SCREEN_NAME" -X stuff $'\003'
   sleep 5
   screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію
fi

screen -dmS "$SCREEN_NAME" -L
screen -S "$SCREEN_NAME" -X logfile "$LOG_FILE"
screen -S "$SCREEN_NAME" -X colon "logfile flush 0^M" 
screen -S "$SCREEN_NAME" -X stuff "cd /root/rl-swarm; python3 -m venv .venv; source .venv/bin/activate; ./run_rl_swarm.sh"
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter

screen -x "$SCREEN_NAME"
# echo "Install Ge$SCREEN_NAMEnsyn"
# MAX_RETRIES=500
# while [ 0 -lt $MAX_RETRIES ]; do
#     # Перевірка, чи існує контейнер "spheronnetwork"
#     if tail -n 1 "$LOG_FILE" | grep -q "Would you like to push models you train in the RL swarm to the Hugging Face Hub?"; then
#       echo "Gensyn успішно запущено."
#       break
#     fi
#     tail -n 3 $LOG_FILE
#     sleep 5
#     ((counter++))
# done
# screen -S "$SCREEN_NAME" -X stuff $'\n'
# echo "Logs - "
# echo "tail -f /root/rl-swarm/logs.log -n 100"
