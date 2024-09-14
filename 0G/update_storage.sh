#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/update_storage.sh) 

if [ -n "$1" ]; then
  PRIVATE_KEY="$1"
else
  read -p "Enter your private key: " PRIVATE_KEY
fi

echo "Private key: $PRIVATE_KEY"

source $HOME/.profile

sudo systemctl stop zgs.service
# cd $HOME/0g-storage-node/
# git checkout -- run/config.toml
# git tag -d $1 > /dev/null 2>&1
# git fetch --all --tags
# git checkout tags/$1 --force
# git submodule update --init

cd $HOME/0g-storage-node
git stash
git fetch --tags
# git fetch --all --tags
git checkout v0.5.1
# git checkout 702680f 
git submodule update --init
# cargo build --release

taskset -c 0,1,2 cargo build --release

#Получаем IP
# ENR_ADDR=$(wget -qO- eth0.me)


rm -rf $HOME/0g-storage-node/run/config.toml
curl -o $HOME/0g-storage-node/run/config.toml https://raw.githubusercontent.com/z8000kr/0g-storage-node/main/run/config.toml
sed -i 's|blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = "https://0g-evm-vps.zstake.xyz"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|miner_key = "your wallet key"|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml


#sed -i 's/debug/info/; s/h2=info/h2=warn/' $HOME/0g-storage-node/run/log_config

#latest_block=$($HOME/go/bin/0gchaind status | jq -r .sync_info.latest_block_height)
#sed -i 's/log_sync_start_block_number = [0-9]\+/log_sync_start_block_number = '"$latest_block"'/g' $HOME/0g-storage-node/run/config.toml

rm -rf $HOME/0g-storage-node/run/db
rm -rf $HOME/0g-storage-node/run/network
rm -rf $HOME/0g-storage-node/run/log

sudo systemctl start zgs.service



echo "tail -f ~/0g-storage-node/run/log/*"
echo "-----------------------------------------------------------------------------"
