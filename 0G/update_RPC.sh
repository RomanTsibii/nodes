#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/update_RPC.sh)

# Запит RPC у користувача
echo "Введите RPC:"
read RPC

sed -i "s|^blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = \"$RPC\"|" "$HOME/0g-storage-node/run/config.toml"

sudo systemctl restart zgs.service &>/dev/null
sudo systemctl restart 0g_storage &>/dev/null
