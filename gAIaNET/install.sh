#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/install.sh)

sudo apt update -y 
sudo apt-get update
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

source ~/.bashrc
source ~/.bashrc

gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

gaianet start





sudo apt install python3-pip -y

sudo apt install nano screen  -y


pip install requests

pip install faker










gaianet info
