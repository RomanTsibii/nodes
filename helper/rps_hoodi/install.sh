#!/bin/bash
set -x
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/rps_hoodi/install.sh)

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
sudo ufw allow 31303/tcp
sudo ufw allow 31303/udp
sudo ufw allow 19000/tcp
sudo ufw allow 19000/udp

sudo ufw allow ssh
echo "y" | sudo ufw enable

cd /root
mkdir -p eth_node_hoodi
cd eth_node_hoodi
mkdir -p data/geth data/lighthouse secrets
openssl rand -hex 32 > secrets/jwt.hex
chmod 600 secrets/jwt.hex
wget -O docker-compose.yml https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/rps_hoodi/docker-compose.yml

docker compose up -d
