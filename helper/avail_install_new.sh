#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_install_new.sh) 
# screen -S avail_helscheck -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_install_new.sh)"

# 1 створити файл з кодом

#!/bin/bash

cat > "$HOME/availscript.sh" << EOF
#!/bin/bash

COMMAND="curl -sL1 avail.sh | bash" 
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

chmod u+x $HOME/availscript.sh
# 2 запустити у ньому у фоні файл

sleep 1
echo "restart avail" 
screen -dmS avail -L
sleep 1
screen -S avail -X colon "logfile flush 0^M"  
sleep 1
screen -S avail -X stuff "bash availscript.sh"
sleep 1
screen -S avail -X stuff $'\n' # press enter

echo "logs - "
echo "tail -Fn 10 screenlog.0"
echo "publick key - "
echo "tail -n 1000 screenlog.0 | grep ""public key:""  | awk '{print $11}' | head -1"
