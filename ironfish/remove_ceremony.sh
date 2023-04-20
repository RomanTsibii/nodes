#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/remove_ceremony.sh)

screen -SX ironfish_ceremony quit
docker-compose down -v
docker stop $(docker network inspect root_default | grep Containers -A 1 | tail -1 | sed 's/\"//g' | awk '{printf$1}')
docker-compose down -v

docker stop $(docker ps | grep iron | tail -1 | rev | cut -d '/' -f1 | rev | awk '{printf$2}')
docker-compose down -v

docker ps | grep ironfish
