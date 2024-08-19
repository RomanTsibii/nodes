#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/update_rps.sh)

echo "Введите RPC"
read RPC

docker compose -f $HOME/allora-huggingface-walkthrough/docker-compose.yaml down
sed -i "/\"nodeRpc\"/ s|\"nodeRpc\": \".*\"|\"nodeRpc\": \"$RPC\"|" $HOME/allora-huggingface-walkthrough/config.json

cd allora-huggingface-walkthrough
chmod +x init.config
./init.config
docker compose -f $HOME/allora-huggingface-walkthrough/docker-compose.yaml up -d
echo "docker compose -f $HOME/allora-huggingface-walkthrough/docker-compose.yaml logs -f"
