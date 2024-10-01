#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/install.sh)
# tail -f /var/log/bot_gaia.log
# tail -f /var/log/bot_gaia.log
# 
# nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &       # start
# kill $(ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}')   # stop
#

cd /root
sudo apt update -y 
# sudo apt-get update
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

source ~/.bashrc
/root/gaianet/bin/gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

/root/gaianet/bin/gaianet run
sleep 10
gaianet_info=$(/root/gaianet/bin/gaianet info)
Node_ID=$(echo "$gaianet_info" | awk -F 'Node ID: ' '{print $2}' | awk '{print $1}')
Device_ID=$(echo "$gaianet_info" | awk -F 'Device ID: ' '{print $2}')

echo "Node_ID: $Node_ID"
echo "Device_ID: $Device_ID"

# gaianet stop

cd /root/gaianet 
wget -O phrases.txt https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/phrases.txt
wget -O bot_config.json https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_config.json
wget -O bot_gaia.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_gaia.sh
wget -O start.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/start.sh

chmod +x bot_gaia.sh
chmod +x start.sh

# sed -i "s/YOUR_WALLET/$Node_ID/" config.json
jq --arg node_id "$Node_ID" '.url = "https://\($node_id).us.gaianet.network/v1/chat/completions"' bot_config.json > temp.json && mv temp.json bot_config.json
sed -i 's/\\u001b\[0m//g' bot_config.json
(sudo crontab -l ; echo "@reboot /root/gaianet/bin/gaianet run >> /var/log/gaianet.log 2>&1 && /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &") | sudo crontab -
nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &   # start
/root/gaianet/bin/gaianet info
