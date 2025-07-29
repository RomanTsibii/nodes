#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/free_memory.sh)

# видалити логи у докері якщо там більше 1гб
sudo find /var/lib/docker/containers/ -type f -name "*.log" -size +1G -exec truncate -s 0 {} \;

rm -rf /var/log/xrdp.log
rm -rf /var/log/bot_gaia.log

# removing all logs
# rm -rf /var/log/*
rm -rf /var/log/syslog /var/log/syslog.1 /var/log/syslog.2
# remove from docker all images with tag "none"
docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

rm -rf  /root/storage_0gchain_snapshot.lz4
sudo journalctl --vacuum-size=100M
sudo systemctl restart systemd-journald
docker rm -f nubit
docker rm -f scout
docker rm -f infera
docker rm -f unichain-node-op-node-1
docker rm -f unichain-node-execution-client-1

docker rm -f nwaku-compose-postgres-exporter-1
docker rm -f text-ui
docker rm -f upscaler
docker rm -f hyperlane
docker rm -f rembg

docker rm -f infernet-node
docker rm -f titan
docker rm -f nwaku-compose-nwaku-1
docker rm -f hyperspace_container_1
docker rm -f hyperspace_container_2
docker rm -f hyperspace_container_3
docker rm -f hyperspace_container_4
docker rm -f hyperspace_container_5
docker rm -f hyperspace_container_6
docker rm -f hyperspace_container_7
docker rm -f hyperspace_container_8
docker rm -f hyperspace_container_9
docker rm -f hyperspace_container_10

docker system prune -a -f
# docker image prune -a -f
# docker builder prune -f
df -h /
echo "systemctl restart docker && docker builder prune -f"
