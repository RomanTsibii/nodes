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

docker image prune -a -f
docker builder prune -f
df -h /
echo "systemctl restart docker && docker builder prune -f"
