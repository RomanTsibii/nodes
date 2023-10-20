#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/start_docker.sh) $PORT


BIG_PORTS="48201 48403 48605 48807 48909 48211 48413 48615 48817 48919 48221 48423 48625 48827 48929 48231 48433 48635 48837 48939 48241 48443 48645 48847 48949 48251 48453 48655 48857 48959 48261 48463 48665 48867 48969 48271 48473 48675 "
SMALL_PORTS="48201 48403 48605 48807 48909 48211 48413 48615 48817 48919 48221"

PORT=$1

# sudo apt update && sudo apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh)

PORT4=$(($PORT+3))

docker stop minima$PORT
docker rm minima$PORT
rm -rf minimadocker$PORT
sleep 2
MINIMA_PASSWORD=bnbiminima

docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker$PORT:/home/minima/data -p $PORT-$PORT4:9001-9004 --restart unless-stopped --name minima$PORT minimaglobal/minima:latest || docker restart minima$PORT 

echo sleep1
sleep 15
echo sleep2
sleep 15
docker run --name watchtower_runonce -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once

docker rm watchtower_runonce
echo DONE
docker ps | grep minima
echo "docker logs -f --tail=100 minima$PORT"
