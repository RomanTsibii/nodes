#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh) token
# 
# логи
# docker-compose -f ~/.spheron/fizz/docker-compose.yml logs  -f
# видалити кронтаб 
sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
sudo crontab -l | grep -v "/bin/bash /root/scripts/spheron/restart.sh" | sudo crontab -

if [ -n "$1" ]; then
  USER_TOKEN="$1"
else
  read -p "Enter your USER_TOKEN: " USER_TOKEN
fi

SCREEN_NAME=spheron_install

function install_docker {
    if ! type "docker" > /dev/null; then
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    fi
}

function install_screen {
    if ! type "screen" > /dev/null; then
        sudo apt update
        sudo apt install screen -y
    fi
}

install_docker
install_screen

docker stop $(docker ps | grep spheronnetwork | awk {'print $1'})
cd /root

# echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X colon "logfile flush 0^M"  
sleep 1
screen -S "$SCREEN_NAME" -X stuff "curl -sL1 https://sphnctl.sh | bash"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter
sleep 40
# screen -S "$SCREEN_NAME" -X stuff "bash $HOME/${SCREEN_NAME}_start.sh"
screen -S "$SCREEN_NAME" -X stuff "sphnctl fizz start --token $USER_TOKEN"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter

MAX_RETRIES=120 # 120 * 5 = 600 секунд(10хв) - очікувати поки не запуститься контейнер сперону
while [ 0 -lt $MAX_RETRIES ]; do
    # Перевірка, чи існує контейнер "spheronnetwork"
    if docker ps | grep -q "spheronnetwork"; then
        echo "Контейнер 'spheronnetwork' запущено."
        break
    else
        echo "Контейнер 'spheronnetwork' не знайдено. Очікування 5 секунд..."
        sleep 5
    fi
    ((counter++))
done

sleep 20
screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію

mkdir -p scripts/spheron && cd scripts/spheron
wget -O restart.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x restart.sh

./restart.sh

(sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */12 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
