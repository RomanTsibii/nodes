#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/install.sh)
cd
sudo apt update -y 
sudo apt-get update
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

source ~/.bashrc
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json
gaianet start

gaianet_info=$(gaianet info)
Node_ID=$(echo "$gaianet_info" | awk -F 'Node ID: ' '{print $2}' | awk '{print $1}')
Device_ID=$(echo "$gaianet_info" | awk -F 'Device ID: ' '{print $2}')

echo "Node_ID: $Node_ID"
echo "Device_ID: $Device_ID"

sudo apt install python3-pip nano screen -y
pip install requests faker
wget -O random_chat_with_faker.py https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/random_chat_with_faker.py

sed -i "s/АДРЕСВАШЕГОКОШЕЛЬКА/$Node_ID/g" $HOME/random_chat_with_faker.py

if [ "$#" -ne 2 ]; then
    echo "Used sleep fron 60 to 180"
else
    new_min="$1"
    new_max="$2"
    sed -i "s/random.randint(60, 180)/random.randint($new_min, $new_max)/g" $HOME/random_chat_with_faker.py
    echo "Used sleep fron $new_min to $new_max"
fi

SESSION_NAME="faker_session_gAIa"

if screen -list | grep -q "$SESSION_NAME"; then
  echo "$SESSION_NAME exixts. close"
  screen -ls | grep "$SESSION_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

screen -dmS "$SESSION_NAME"
sleep 1
# Виконання команди в новій сесії
screen -S "$SESSION_NAME" -X stuff "python3 ~/random_chat_with_faker.py"
sleep 1
screen -S "$SESSION_NAME" -X stuff $'\n' # натискання Enter
