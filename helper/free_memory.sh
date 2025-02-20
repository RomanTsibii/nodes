#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/free_memory.sh)

# remove from docker all images with tag "none"
docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

# removing all logs
# rm -rf /var/log/*
rm -rf /var/log/syslog /var/log/syslog.1 /var/log/syslog.2



sudo journalctl --vacuum-size=100M
sudo systemctl restart systemd-journald

# видалити логи у докері якщо там більше 1гб
sudo find /var/lib/docker/containers/ -type f -name "*.log" -size +1G -exec truncate -s 0 {} \;


docker builder prune -f
df -h /
echo "systemctl restart docker && docker builder prune -f"
