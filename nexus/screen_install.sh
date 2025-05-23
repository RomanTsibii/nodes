#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/screen_install.sh) prover_id

if [ -n "$1" ]; then
  prover_id="$1"
else
  read -p "Enter your prover id: " prover_id
fi

SESSION_NAME="nexus"
LOG_FILE="/var/log/nexus.log"

if screen -list | grep -q "$SESSION_NAME"; then
  echo "Сесія $SESSION_NAME вже існує. Закриття..."
  screen -ls | grep "$SESSION_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

mkdir -p /root/.nexus && cd /root/.nexus
echo "$prover_id" > prover-id
# Запуск нової сесії
# screen -dmS "$SESSION_NAME"
bash -c "screen -dmS \"$SESSION_NAME\""

sleep 1
# добавити файл логування
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on
# screen -S "$SESSION_NAME" -X stuff "echo $SHELL"
# screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
# screen -S "$SESSION_NAME" -X stuff "sleep 20"
# screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter

# Виконання команди в новій сесії
# screen -S "$SESSION_NAME" -X stuff "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/install.sh)"
# screen -S "$SESSION_NAME" -X stuff "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/testnet2.sh) $prover_id"
screen -S "$SESSION_NAME" -X stuff "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/testnet2.sh) $prover_id"
# screen -S "$SESSION_NAME" -X stuff "curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/testnet2.sh | bash -s $prover_id"
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
sleep 1

# screen -S "$SESSION_NAME" -X stuff "$prover_id" # натискання Enter
# sleep 1
# screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
