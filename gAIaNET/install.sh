#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/install.sh)
cd /root
sudo apt update -y 
# sudo apt-get update
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash

source ~/.bashrc
gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

gaianet run
gaianet_info=$(gaianet info)
Node_ID=$(echo "$gaianet_info" | awk -F 'Node ID: ' '{print $2}' | awk '{print $1}')
Device_ID=$(echo "$gaianet_info" | awk -F 'Device ID: ' '{print $2}')

echo "Node_ID: $Node_ID"
echo "Device_ID: $Device_ID"

# gaianet stop

cd /root/gaianet 
wget -O phrases.txt https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/phrases.txt
wget -O bot_config.json https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_config.json
wget -O bot_gaia.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_gaia.sh
chmod +x bot_gaia.sh
# sed -i "s/YOUR_WALLET/$Node_ID/" config.json
jq --arg node_id "$Node_ID" '.url = "https://\($node_id).us.gaianet.network/v1/chat/completions"' bot_config.json > temp.json && mv temp.json bot_config.json
sed -i 's/\\u001b\[0m//g' bot_config.json

sudo bash -c "cat > /etc/systemd/system/bot_gaia.service" <<EOL
[Unit]
Description=Bot Gaia Service
After=gaianet.service
Requires=gaianet.service

[Service]
ExecStart=/bin/bash /root/gaianet/bot_gaia.sh
Restart=on-failure
User=root
WorkingDirectory=/root/gaianet
Environment=GAIANET_ENV=production

[Install]
WantedBy=multi-user.target
EOL

sudo bash -c "cat > /etc/systemd/system/gaianet.service" <<EOL
[Unit]
Description=GaiaNet Node Service
After=network.target

[Service]
Type=oneshot
ExecStart=/root/gaianet/bin/gaianet run
ExecStop=/root/gaianet/bin/gaianet stop
RemainAfterExit=true
PIDFile=/var/run/gaianet.pid
Restart=on-failure
User=root
WorkingDirectory=/root/gaianet
Environment=GAIANET_ENV=production

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable gaianet.service
sudo systemctl enable bot_gaia.service
sudo systemctl start gaianet.service
sudo systemctl start bot_gaia.service
# sudo systemctl status gaianet --no-pager

echo "journalctl -xeu gaianet.service -f"
echo "journalctl -xeu bot_gaia.service -f"
gaianet info

