#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/sonaric/create_backup.sh) token

if [ -n "$1" ]; then
  pass="$1"
else
  read -p "Enter your pass: " pass
fi

function install_screen {
    if ! type "screen" > /dev/null; then
        sudo apt update
        sudo apt install screen -y
    fi
}

install_screen

SCREEN_NAME=sonaric_backup
cd /root
screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію

# echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X stuff "sonaric identity-export -o $HOME/.sonaric/identity.file\n"
sleep 5
screen -S "$SCREEN_NAME" -X stuff "$pass\n" # press enter
sleep 5
screen -S "$SCREEN_NAME" -X stuff "$pass\n" # press enter
sleep 5
screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію
