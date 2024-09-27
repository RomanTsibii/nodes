#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nillion/install.sh)

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


sudo apt update # && sudo apt upgrade -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
install_docker
docker --version

docker pull nillion/verifier:v1.0.1
mkdir -p nillion/verifier
docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise
# cat nillion/verifier/credentials.json 
mkdir -p nillion_backups
cp nillion/verifier/credentials.json nillion_backups/credentials.json
cat nillion_backups/credentials.json

docker run -d --name nillion -v $HOME/nillion/accuser:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
docker cp /root/nillion/verifier/credentials.json nillion:/var/tmp/credentials.json
docker restart nillion
