#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh)
# 
# логи
# docker-compose -f ~/.spheron/fizz/docker-compose.yml logs  -f
# видалити кронтаб 
sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
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

echo "Germany GATEWAY_ADDRESS:gwger.testnetcsphn.xyz"
echo "Spain GATEWAY_ADDRESS:gwsp.testnetcsphn.xyz"
echo "FRANCE GATEWAY_ADDRESS:provider.testnetbsphn.xyz"
echo "BULGARIA GATEWAY_ADDRESS:provider.vycod.com"
echo "ROMANIA GATEWAY_ADDRESS:gwrom.testnetcsphn.xyz"
echo "TURKEY GATEWAY_ADDRESS:gwa.testnetcsphn.xyz"
echo "SINGAPORE GATEWAY_ADDRESS:gwsing.testnetcsphn.xyz"
echo "CHINA GATEWAY_ADDRESS:gwhong.testnetcsphn.xyz"

if [ -n "$3" ]; then
  GATEWAY_ADDRESS="$3"
else
  read -p "Enter your GATEWAY_ADDRESS: " GATEWAY_ADDRESS
  # GATEWAY_ADDRESS=gwger.testnetcsphn.xyz
fi

echo "WALLET_ADDRESS: $WALLET_ADDRESS"
echo "USER_TOKEN: $USER_TOKEN"
echo "GATEWAY_ADDRESS: $GATEWAY_ADDRESS"

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
wget -O install.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/install_file.sh
wget -O restart.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x install.sh
chmod +x restart.sh

sed -i "s|WALLET_ADDRESS=\"[^\"]*\"|WALLET_ADDRESS=\"$WALLET_ADDRESS\"|" install.sh
sed -i "s|USER_TOKEN=\"[^\"]*\"|USER_TOKEN=\"$USER_TOKEN\"|" install.sh
sed -i "s|GATEWAY_ADDRESS=\"[^\"]*\"|GATEWAY_ADDRESS=\"$GATEWAY_ADDRESS\"|" install.sh

./install.sh
sleep 30
./restart.sh

(sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */12 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
