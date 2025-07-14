#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/install.sh)

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

cd /root
echo -e "${BLUE}Установка ноды Gensyn...${NC}"

# Обновление и установка зависимостей
# sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get update
sudo apt-get install -y nvidia-cuda-toolkit
sudo apt install screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev  -y

sudo apt install python3 python3-pip python3-venv python3-dev -y

sudo apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
node -v
npm install -g yarn
yarn -v

sleep 1

git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm

python3 -m venv .venv
source .venv/bin/activate

wget -O login_v1.py https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gensyn/login_v1.py
# добавляємо файл для авто логіну через пошту по IMAP
if ! grep -q "python3 login_v1.py" /root/rl-swarm/run_rl_swarm.sh; then
    sed -i '/echo_green ">> Waiting for modal userData\.json to be created\.\.\."/i\    python3 login_v1.py' /root/rl-swarm/run_rl_swarm.sh
fi

pip3 install selenium imapclient pyzmail36 webdriver-manager

# 1. Перевірка та встановлення Google Chrome
if ! command -v google-chrome > /dev/null 2>&1; then
    echo "Встановлюю Google Chrome..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt update
    sudo apt install -y google-chrome-stable
else
    echo "Google Chrome вже встановлено."
fi

echo "For getting email app code go to https://myaccount.google.com/apppasswords, before need turn on 2FA"
echo "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/restart.sh)"
echo "logs tail -f /root/rl-swarm/logs.log -n 100" 
