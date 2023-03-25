#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/starknet_remove_db.sh)

du -sh $HOME/pathfinder/pathfinder

cd $HOME/pathfinder/
docker-compose down -v
rm -rf $HOME/pathfinder/pathfinder
mkdir -p $HOME/pathfinder/pathfinder
chown -R 1000.1000 .
docker-compose up -d

du -sh $HOME/pathfinder/pathfinder
