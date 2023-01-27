#!/bin/bash

# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/update.sh)

docker-compose down
docker-compose pull
docker-compose run --rm --entrypoint "./bin/run migrations:start" ironfish
docker-compose up -d

sleep 20

docker exec ironfish ./bin/run  status

echo "docker-compose logs -f --tail=100"
