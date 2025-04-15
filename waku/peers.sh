#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/waku/peers.sh)

peers=$(docker compose -f /root/nwaku-compose/docker-compose.yml logs --tail=300000 | grep totalConnections | tail -1 | awk '{print $16}')
sleep 5
echo $peers
