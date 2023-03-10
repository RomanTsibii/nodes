#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/remove_and_install_fail_docker.sh) 

PORT=$1
docker stop minima$PORT
docker rm -f `docker ps -a | grep minima$PORT | awk '{print $1}'`
rm -rf $HOME/minimadocker$PORT

PORT4=$((PORT+3))
MINIMA_PASSWORD=bnbiminima
docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker$PORT:/home/minima/data -p $PORT-$PORT4:9001-9004 --restart unless-stopped --name minima$PORT minimaglobal/minima:latest


