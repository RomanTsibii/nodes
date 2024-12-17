#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kuzco/restart_always.sh) 
# screen -S kuzco_restart -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kuzco/restart_always.sh)"

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

if screen -list | grep -q "$SESSION_NAME"; then
  echo "Сесія $SESSION_NAME вже існує. Закриття..."
  screen -ls | grep "$SESSION_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

# Створення скрипта з коректною підстановкою змінної
cat > "$HOME/kuzco_start.sh" << EOF
#!/bin/bash

COMMAND="\$(cat << 'CMD_EOF'
$COMMAND
CMD_EOF
)"

while true; do
    echo "Starting command: \$COMMAND"
    bash -c "\$COMMAND" &
    PID=\$!
    wait \$PID
    EXIT_STATUS=\$?
    if [ \$EXIT_STATUS -eq 0 ]; then
        echo "Command exited successfully. Restarting..."
    else
        echo "Command failed with status \$EXIT_STATUS. Restarting..."
    fi
    sleep 10
done
EOF


chmod u+x "$HOME/${SESSION_NAME}_start.sh"

# 2 запустити у ньому у фоні файл

sleep 1
echo "restart $SESSION_NAME" 
screen -dmS kuzco -L
sleep 1
screen -S kuzco -X colon "logfile flush 0^M"  
sleep 1
screen -S kuzco -X stuff "bash $HOME/${SESSION_NAME}_start.sh"
sleep 1
screen -S kuzco -X stuff $'\n' # press enter
