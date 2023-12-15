#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/change_RPS.sh) RPS

RPS="$1"


sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-single-proc-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-double-proc-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-triple-proc-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-quad-proc-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-snapshot-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-cryptopunks-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/my-ens-squid/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$HOME/simple-busd-subgraph/docker-compose.yml"

cat $config_path | grep RPC_URL:
