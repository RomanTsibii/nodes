#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/waku/peers.sh)

docker compose -f /root/nwaku-compose/docker-compose.yml logs --tail=30000 | grep totalConnections | tail -1
