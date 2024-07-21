#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/waku/update_rps.sh) rps_sepolia

RPS=$1
docker-compose -f /root/nwaku-compose/docker-compose.yml down
sed -i "s|^ETH_CLIENT_ADDRESS=.*|ETH_CLIENT_ADDRESS=${RPS}|" /root/nwaku-compose/.env
docker-compose -f /root/nwaku-compose/docker-compose.yml up -d
