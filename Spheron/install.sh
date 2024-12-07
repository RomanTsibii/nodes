#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh)
# логи
# видалити кронтаб 

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


зайти у папку скрыпт і створити якщо нема 
зайти у папку спхерон і створити якщо нема 
curl -O https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/install.sh записати у install.sh

# замінити значення WALLET_ADDRESS 
# замінити значення USER_TOKEN

# скачати файл злому 
# створити код для запуску кронтабу у якому буде рестарт і запуск злому 


