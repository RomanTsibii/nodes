#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/freeing_memory.sh)

# remove from docker all images with tag "none"
docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

#subspace
#docker rmi $(docker images | grep subspace | awk '{print$3}')

docker rmi $(docker images | grep aptos | awk '{print$3}')

# removing all logs
rm -rf /var/log/*

# massa tar files
rm -rf $HOME/massa_TEST.1*

# sui old logs
rm -rf $HOME/sui.log*
