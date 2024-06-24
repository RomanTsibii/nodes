#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/check_all_logs.sh )

node_number=$1
docker logs --tail=5 nubit$node_number
