#!/bin/sh

# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/install_via_docker_for_andrii.sh)

sudo apt update && sudo apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh)
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)

MINIMA_PASSWORD=andriy12548

docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker19001:/home/minima/data -p 19001-19004:9001-9004 --restart unless-stopped --name minima19001 minimaglobal/minima:latest

sleep 10

docker run -d --restart unless-stopped --name watchtower -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

sleep 10

docker ps

