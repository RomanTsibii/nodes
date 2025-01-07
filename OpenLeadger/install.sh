#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/OpenLeadger/install.sh)

function install_docker {
    if ! type "docker" > /dev/null; then
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    fi
}

sudo apt update # && sudo apt upgrade -y
install_docker
docker --version
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    xfce4 \
    xfce4-goodies \
    gdebi \
    wget \
    unzip
sudo apt install -y xrdp
echo "xfce4-session" > /root/.xsession
systemctl enable xrdp
systemctl restart xrdp
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
