#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/check_all_containers.sh )

node_number=$1
docker logs -f --tail=100 nubit$node_number
