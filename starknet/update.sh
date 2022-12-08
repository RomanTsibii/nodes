#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/update.sh)

cd $HOME/pathfinder
docker-compose down
docker-compose pull
docker-compose up -d

docker-compose -f $HOME/pathfinder/docker-compose.yml logs -f --tail=10
