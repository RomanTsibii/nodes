#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/update_RPC_bace.sh)

echo "Введите RPC"
read RPC

docker compose -f $HOME/basic-coin-prediction-node/docker-compose.yml down
sed -i "/\"nodeRpc\"/ s|\"nodeRpc\": \".*\"|\"nodeRpc\": \"$RPC\"|" $HOME/basic-coin-prediction-node/config.json

cd basic-coin-prediction-node
chmod +x init.config
./init.config
docker compose -f $HOME/basic-coin-prediction-node/docker-compose.yml up -d
