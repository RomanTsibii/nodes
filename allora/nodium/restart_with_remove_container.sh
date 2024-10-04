#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/restart_with_remove_container.sh)

echo "----------------------------------------------------------------------"
echo "Script started at: $(date '+%d.%m.%Y %H:%M')"
# зупинка контейнерів
docker compose -f $HOME/worker1-10m/docker-compose.yml down -v
docker compose -f $HOME/worker2-24h/docker-compose.yml down -v
docker compose -f $HOME/worker3-20m/docker-compose.yml down -v 

# видалити всі контейнери з алорою 
docker ps -a | grep allora | awk '{print $1}' | xargs docker rm -f

# видалити всі images з алорою 
docker images | grep worker | awk '{print $3}' | xargs docker rmi -f

# видалити всі network з алорою 
docker network rm worker1-10m_default worker2-24h_default worker3-20m_default

# видалити всі volume з алорою 
docker volume prune -f

# запуск контейнерів
docker compose -f $HOME/worker1-10m/docker-compose.yml up -d --build
# docker compose -f $HOME/worker2-24h/docker-compose.yml up -d --build
docker compose -f $HOME/worker3-20m/docker-compose.yml up -d --build
