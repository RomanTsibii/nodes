#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/install3test.sh)

curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_docker.sh | bash

echo "alias ironfish='docker exec ironfish ./bin/run'" >> ~/.profile
source ~/.profile

sudo tee <<EOF >/dev/null $HOME/docker-compose.yaml
version: "3.3"
services:
 ironfish:
  container_name: ironfish
  image: ghcr.io/iron-fish/ironfish:latest
  restart: always
  entrypoint: sh -c "sed -i 's%REQUEST_BLOCKS_PER_MESSAGE.*%REQUEST_BLOCKS_PER_MESSAGE = 5%' /usr/src/app/node_modules/ironfish/src/syncer.ts && apt update > /dev/null && apt install curl -y > /dev/null; ./bin/run start"
  healthcheck:
   test: "curl -s -H 'Connection: Upgrade' -H 'Upgrade: websocket' http://127.0.0.1:9033 || killall5 -9"
   interval: 180s
   timeout: 180s
   retries: 3
  volumes:
   - $HOME/.ironfish:/root/.ironfish
EOF

docker-compose pull && docker-compose up -d

IRONFISH_NODENAME=`ironfish config | grep nodeName | awk '{print $2}' | sed 's/\"//g' |  tr ',' ' '`
echo 'export NODENAME='$IRONFISH_NODENAME >> $HOME/.profile
source ~/.profile

if [ -z $IRONFISH_NODENAME ]; then
        read -p "Введите ваше имя ноды (придумайте, без спецсимволов - только буквы и цифры): " IRONFISH_NODENAME
        echo 'export NODENAME='$IRONFISH_NODENAME >> $HOME/.profile
        source ~/.profile
fi

echo $IRONFISH_NODENAME

ironfish wallet:create $IRONFISH_NODENAME

ironfish wallet:use $IRONFISH_NODENAME

ironfish config:set nodeName $IRONFISH_NODENAME

ironfish config:set blockGraffiti $IRONFISH_NODENAME

ironfish config:set minerBatchSize 60000

ironfish config:set enableTelemetry true

sleep 5

ironfish status

echo "docker-compose logs -f --tail=100"

