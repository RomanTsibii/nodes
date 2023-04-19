#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/subspace/update_subspace.sh)

docker-compose -f $HOME/subspace_docker/docker-compose.yml logs -f --tail=100 node
