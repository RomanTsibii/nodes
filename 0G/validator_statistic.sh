#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/validator_statistic.sh) 

rpc_port=$(grep -m 1 -oP '^laddr = "\K[^"]+' "$HOME/.0gchain/config/config.toml" | cut -d ':' -f 3)
while true; do
  local_height=$(curl -s localhost:$rpc_port/status | jq -r '.result.sync_info.latest_block_height')
  # network_height=$(curl -s https://og-testnet-rpc.itrocket.net/status | jq -r '.result.sync_info.latest_block_height')
  network_height=$(curl -s https://api.oneiricts.com:8445/cosmos/base/tendermint/v1beta1/blocks/latest | jq -r '.block.header.height')

  if ! [[ "$local_height" =~ ^[0-9]+$ ]] || ! [[ "$network_height" =~ ^[0-9]+$ ]]; then
    echo -e "\033[1;31mError: Invalid block height data. Retrying...\033[0m"
    sleep 5
    continue
  fi

  blocks_left=$((network_height - local_height))
  if [ "$blocks_left" -lt 0 ]; then
    blocks_left=0
  fi

  echo -e "\033[1;33mYour Node Height:\033[1;34m $local_height\033[0m \033[1;33m| Network Height:\033[1;36m $network_height\033[0m \033[1;33m| Blocks Left:\033[1;31m $blocks_left\033[0m"

  sleep 5
done
