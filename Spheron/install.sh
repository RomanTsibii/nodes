#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh) token
# 
# логи
# journalctl -u cheker_spheron.service --no-pager -n 20
# логи  заміни даних
# journalctl -u cheker_spheron.service -f
# видалити кронтаб 
sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
sudo crontab -l | grep -v "/bin/bash /root/scripts/spheron/restart.sh" | sudo crontab -

if [ -n "$1" ]; then
  USER_TOKEN="$1"
else
  read -p "Enter your USER_TOKEN: " USER_TOKEN
fi

SCREEN_NAME=spheron_install
LOG_FILE="/var/log/spheron_logs_installing.log"

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
echo "Start install spheron, just wait for install..."

# docker stop $(docker ps | grep spheronnetwork | awk {'print $1'})
cd /root
screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію

# echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X logfile "$LOG_FILE"
screen -S "$SCREEN_NAME" -X colon "logfile flush 0^M"  
sleep 1
screen -S "$SCREEN_NAME" -X stuff "curl -sL1 https://sphnctl.sh | bash;sphnctl fizz start --token $USER_TOKEN"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter
# sleep 40
# # screen -S "$SCREEN_NAME" -X stuff "bash $HOME/${SCREEN_NAME}_start.sh"
# screen -S "$SCREEN_NAME" -X stuff "sphnctl fizz start --token $USER_TOKEN"
# sleep 1
# screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter

echo "Install spheron"

MAX_RETRIES=120 # 120 * 25 = 3000 секунд(50хв) - очікувати поки не запуститься контейнер сперону
echo "" > "$LOG_FILE"
while [ 0 -lt $MAX_RETRIES ]; do
    # Перевірка, чи існує контейнер "spheronnetwork"
    if grep -q "Waiting for fizz-node container to start" "$LOG_FILE"; then
      echo "Знайдено 'Fizz Is Installed and Running successfully' у логах."
      # Waiting for fizz-node container to start # старе
      # Fizz Is Installed and Running successfully # нове
      break
    fi
    echo "."
    sleep 25
    ((counter++))
done

sleep 5
screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I{} screen -S {} -X quit # закрити скрін сесію

mkdir -p scripts/spheron && cd scripts/spheron
wget -O restart.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x restart.sh

sudo curl -o /etc/systemd/system/cheker_spheron.service https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/cheker_spheron.service
sudo systemctl daemon-reload
sudo systemctl enable cheker_spheron.service
sudo systemctl start cheker_spheron.service
sudo systemctl restart cheker_spheron.service

# ./restart.sh

sphnctl fizz stop

docker-compose -f ~/.spheron/fizz/docker-compose.yml down
docker-compose -f ~/.spheron/fizz/docker-compose.yml up -d

sleep 15
journalctl -u cheker_spheron.service --no-pager -n 20

# ./restart.sh

# name=$(docker ps --format "{{.Image}} {{.Names}}" | grep "spheronnetwork" | awk '{print $2}')
# docker exec $name free -h

# docker-compose -f ~/.spheron/fizz/docker-compose.yml up -d

# (sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */3 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
