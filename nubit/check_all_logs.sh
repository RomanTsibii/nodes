#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/check_all_logs.sh 5 -1)

logs=$1
number=$2
docker logs --tail=$logs nubit$number
