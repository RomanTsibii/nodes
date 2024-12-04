#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/infera/install.sh)

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


curl -fsSL https://ollama.com/install.sh | sh
# rm -rf ~/infera
# curl -O https://www.infera.org/scripts/infera-linux-intel.sh
# chmod +x ./infera-linux-intel.sh
# ./infera-linux-intel.sh
# grep 'alias init-infera' ~/.bashrc
# source ~/.bashrc
mkdir ~/infera-docker
cd ~/infera-docker
curl -O http://161.97.84.217/infera
chmod +x infera
# cp ~/infera ~/infera-docker/

curl -O https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/infera/Dockerfile
docker build -t infera-app .
docker run -d --name infera --restart always --network="host" infera-app

echo "------------------logs------------------" 
echo "docker logs -f infera"

echo "------------------Node------------------"
echo "curl -X 'GET' 'http://localhost:11025/node_details' -H 'accept: application/json'"

echo "------------------Points------------------"
echo "curl -s http://localhost:11025/points | jq"
