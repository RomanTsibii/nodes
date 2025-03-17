#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/waku/update_rps.sh) rps_sepolia

if [ -n "$1" ]; then
  RPS="$1"
else
  read -p "Enter your RPS: " RPS
fi

docker-compose -f /root/nwaku-compose/docker-compose.yml down
sed -i "s|^RLN_RELAY_ETH_CLIENT_ADDRESS=.*|RLN_RELAY_ETH_CLIENT_ADDRESS=${RPS}|" /root/nwaku-compose/.env
docker-compose -f /root/nwaku-compose/docker-compose.yml up -d
