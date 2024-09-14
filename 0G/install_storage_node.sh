#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_node.sh)
# screen -S 0G_install_stoprage_node -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_node.sh)"

sudo apt update && sudo apt upgrade -y

if [ -n "$1" ]; then
  PRIVATE_KEY="$1"
else
  read -p "Enter your private key: " PRIVATE_KEY
fi

echo "Private key: $PRIVATE_KEY"

# rm -rf 0g-storage-node


cd $HOME


STORAGE_VERSION="v0.5.1"
echo "STORAGE VERSION: $STORAGE_VERSION"

if [ ! -d "./0g-storage-node" ]; then
  sudo apt update && sudo apt upgrade -y 
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh) &>/dev/null
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/rust.sh) &>/dev/null
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh) &>/dev/null
  sudo apt install --fix-broken -y &>/dev/null
  sudo apt install nano mc wget build-essential git jq make gcc tmux chrony lz4 unzip ncdu htop -y &>/dev/null
  source .profile
  source .bashrc
  sleep 1
  echo "Весь необходимый софт установлен"
  echo "-----------------------------------------------------------------------------"
  git clone -b $STORAGE_VERSION https://github.com/0glabs/0g-storage-node.git
  cd 0g-storage-node
  git submodule update --init
  taskset -c 0,1,2 cargo build --release
else
  cd $HOME/0g-storage-node/
  git checkout -- run/config.toml
  git tag -d $STORAGE_VERSION > /dev/null 2>&1
  git fetch --all --tags
  git checkout tags/$STORAGE_VERSION --force
  git submodule update --init
  sudo systemctl stop zgs
  taskset -c 0,1,2 cargo build --release
fi

cd 0g-storage-node


echo "Репозиторий успешно склонирован, начинаем настройку переменных"
echo "-----------------------------------------------------------------------------"
# Получение приватного ключа
# PRIVATE_KEY=$($HOME/go/bin/0gchaind keys unsafe-export-eth-key wallet2 --keyring-backend test)
ADDRES=$(echo "0x$(0gchaind debug addr $(0gchaind keys show wallet2 -a --keyring-backend test) | grep hex | awk '{print $3}')")
#Получаем IP
ENR_ADDR=$(wget -qO- eth0.me)

echo export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log" >> ~/.bash_profile
echo export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config" >> ~/.bash_profile
echo export ENR_ADDR=${ENR_ADDR} >> ~/.bash_profile
echo export LOG_CONTRACT_ADDRESS="0xbD2C3F0E65eDF5582141C35969d66e34629cC768" >> ~/.bash_profile
echo export MINE_CONTRACT="0x6815F41019255e00D6F34aAB8397a6Af5b6D806f" >> ~/.bash_profile
echo export REWARD_CONTRACT="0x51998C4d486F406a788B766d93510980ae1f9360" >> ~/.bash_profile
source ~/.bash_profile

echo -e "ZGS_LOG_DIR: $ZGS_LOG_DIR\nZGS_LOG_CONFIG_FILE: $ZGS_LOG_CONFIG_FILE\nENR_ADDR: $ENR_ADDR"

sed -i 's|# log_config_file = "log_config"|log_config_file = "'"$ZGS_LOG_CONFIG_FILE"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_directory = "log"|log_directory = "'"$ZGS_LOG_DIR"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^\s*#\?\s*network_enr_address\s*=\s*".*"\s*|network_enr_address = "'"$ENR_ADDR"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# mine_contract_address = ".*"|mine_contract_address = "'"$MINE_CONTRACT"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *log_sync_start_block_number = [0-9]\+|log_sync_start_block_number = 595059|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *confirmation_block_count = [0-9]\+|confirmation_block_count = 6|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_contract_address = ".*"|log_contract_address = "'"$LOG_CONTRACT_ADDRESS"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_dir = "network"|network_dir = "network"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_enr_tcp_port = 1234|network_enr_tcp_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_enr_udp_port = 1234|network_enr_udp_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_libp2p_port = 1234|network_libp2p_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_discovery_port = 1234|network_discovery_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_boot_nodes = \[\]|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS", "/ip4/8.154.47.100/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX"\]|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# db_dir = "db"|db_dir = "db"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# blockchain_rpc_endpoint = "http://127.0.0.1:8545"|blockchain_rpc_endpoint = "https://evmrpc-testnet.0g.ai"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# rpc_enabled = true|rpc_enabled = true|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# auto_sync_enabled = false|auto_sync_enabled = true|' $HOME/0g-storage-node/run/config.toml
sed -i '/# shard_position = "0\/2"/a reward_contract_address = "'"$REWARD_CONTRACT"'"' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *db_max_num_sectors = [0-9]\+|db_max_num_sectors = 1000000000|' $HOME/0g-storage-node/run/config.toml

#sed -i 's/debug/info/; s/h2=info/h2=warn/' $HOME/0g-storage-node/run/log_config

#latest_block=$($HOME/go/bin/0gchaind status | jq -r .sync_info.latest_block_height)
#sed -i 's/log_sync_start_block_number = [0-9]\+/log_sync_start_block_number = '"$latest_block"'/g' $HOME/0g-storage-node/run/config.toml
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=0G Storage Node
After=network.target

[Service]
User=$USER
Type=simple
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
CPUQuota=70%
# MemoryMax=8G

[Install]
WantedBy=multi-user.target
EOF

rm -rf $HOME/0g-storage-node/run/db
rm -rf $HOME/0g-storage-node/run/network
rm -rf $HOME/0g-storage-node/run/log


sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl restart zgs

echo "0G Storage Node успешно обновлена"
echo "-----------------------------------------------------------------------------"
