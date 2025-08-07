#!/bin/bash
set -x
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/rps_sepolia/install.sh)

# оновити час
echo "set Ukraine timezone"
sudo timedatectl set-timezone Europe/Kiev  # old
sudo timedatectl set-timezone Europe/Kyiv  # new

# встановити tmux
# встановити ncdu
sudo apt install ncdu tmux htop screen python3-pip python3-requests -y
sudo pip3 install requests

 # встановити докер
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)

sudo ufw allow OpenSSH
sudo ufw allow 8545/tcp
sudo ufw allow 8546/tcp
sudo ufw allow 8551/tcp
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp
sudo ufw allow 5052/tcp
sudo ufw allow ssh
echo "y" | sudo ufw enable

cd /root
mkdir -p eth-node/{geth-data,lighthouse-data,shared}
cd eth-node
openssl rand -hex 32 | tr -d "\n" > shared/jwt.hex
wget -O docker-compose.yml https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/rps_sepolia/docker-compose.yml

docker compose up -d
