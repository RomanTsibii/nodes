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

function install_docker {
    if ! type "docker" > /dev/null; then
        echo "Устанавливаем докер"
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    else
        echo "Докер уже установлен. Переходим на следующий шаг"
    fi
}

cd /root
curl -sL1 https://sphnctl.sh | bash
# Запустити команду у фоновому режимі
sphnctl fizz start --token $USER_TOKEN &
# Зберегти PID (Process ID) команди
COMMAND_PID=$!
# Затримка на 4 хвилини (240 секунд)
sleep 240
# Зупинити процес
kill $COMMAND_PID

mkdir -p scripts/spheron && cd scripts/spheron
wget -O restart.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x restart.sh

./restart.sh

(sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */12 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
