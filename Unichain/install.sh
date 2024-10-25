#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Unichain/install.sh)
# sudo journalctl -u rivalz.service  -n 80 -f


git clone https://github.com/Uniswap/unichain-node
cd /root/unichain-node
sed -i '/^OP_NODE_L1_ETH_RPC/c\OP_NODE_L1_ETH_RPC=https://ethereum-sepolia-rpc.publicnode.com' .env.sepolia


