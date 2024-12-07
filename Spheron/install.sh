#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh)
# 
# логи
# docker-compose -f ~/.spheron/fizz/docker-compose.yml logs  -f
# видалити кронтаб 
# sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
sudo crontab -l | grep -v "/bin/bash /root/scripts/spheron/restart.sh" | sudo crontab -

if [ -n "$1" ]; then
  WALLET_ADDRESS="$1"
else
  read -p "Enter your WALLET_ADDRESS: " WALLET_ADDRESS
fi

if [ -n "$2" ]; then
  USER_TOKEN="$2"
else
  read -p "Enter your USER_TOKEN: " USER_TOKEN
fi

echo "WALLET_ADDRESS: $WALLET_ADDRESS"
echo "USER_TOKEN: $USER_TOKEN"

function colors {
  GREEN="\e[32m"
  YELLOW="\e[33m"
  RED="\e[39m"
  NORMAL="\e[0m"
}


function install_docker {
    if ! type "docker" > /dev/null; then
        echo -e "${YELLOW}Устанавливаем докер${NORMAL}"
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    else
        echo -e "${YELLOW}Докер уже установлен. Переходим на следующий шаг${NORMAL}"
    fi
}

cd /root

mkdir -p scripts/spheron && cd scripts/spheron
curl -s -O https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/install.sh
curl -s -O https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x install.sh
chmod +x restart.sh

sed -i "s|WALLET_ADDRESS=\"[^\"]*\"|WALLET_ADDRESS=\"$WALLET_ADDRESS\"|" install.sh
sed -i "s|USER_TOKEN=\"[^\"]*\"|USER_TOKEN=\"$USER_TOKEN\"|" install.sh

./install.sh
./restart.sh

(sudo crontab -l ; echo "@reboot sleep 120; /root/scripts/spheron/restart.sh") | sudo crontab -
RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */12 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
