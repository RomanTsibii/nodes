#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/install_screen.sh)
# screen -S run_nubit -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/install_screen.sh)"
# глянути логи  - "tail -f -n 10 /var/log/nubit.log"
# глянути останній рялок логу - "tail -n 1 /var/log/nubit.log"


SESSION_NAME="nubit_node"
LOG_FILE="/var/log/nubit.log"

# Запуск нової сесії
screen -dmS "$SESSION_NAME"
sleep 1
# добавити файл логування 
screen -S "$SESSION_NAME" -X logfile "$LOG_FILE"
screen -S "$SESSION_NAME" -X log on
# Виконання команди в новій сесії
screen -S "$SESSION_NAME" -X stuff "curl -sL1 https:// nubit.sh/ | bash"
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter  
