#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/staking.sh)

tmux kill-session -t shardeum_healthcheck
tmux new-session -d -s shardeum_healthcheck 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/health.sh)'
docker exec -it shardeum-dashboard operator-cli start
sleep 30
source $HOME/.profile
for ((n=0;n<10;n++)); do  STAKE_SHARDEUM;  sleep 10; done
