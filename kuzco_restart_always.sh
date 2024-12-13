#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kuzco/kuzco_install_new.sh) 
# screen -S kuzco_restart -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kuzco/kuzco_install_new.sh)"


cat > "$HOME/kuzco_start.sh" << EOF
#!/bin/bash

COMMAND="kuzco worker start --worker 9lAcOR8E41QkT8kYxEUrC --code b4004c7c-7039-46d5-8153-62cca8fe6b45" 
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

chmod u+x $HOME/kuzco_start.sh
# 2 запустити у ньому у фоні файл

sleep 1
echo "restart kuzco" 
screen -dmS kuzco -L
sleep 1
screen -S kuzco -X colon "logfile flush 0^M"  
sleep 1
screen -S kuzco -X stuff "bash kuzco_start.sh"
sleep 1
screen -S kuzco -X stuff $'\n' # press enter
