#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_v3.sh)

if [ -n "$1" ]; then
  PRIVATE_KEY="$1"
else
  read -p "Enter your PRIVATE_KEY (without the 0x prefix): " PRIVATE_KEY
fi

echo "Устанавливаем софт (временной диапазон ожидания ~5-15 min.)"
echo "-----------------------------------------------------------------------------"
sudo apt update && sudo apt upgrade -y 
echo "Instaling tools..."
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash 
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/rust.sh | bash 
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh | bash 
sudo apt install --fix-broken -y &>/dev/null
sudo apt install nano mc wget build-essential git jq make gcc tmux chrony lz4 unzip ncdu htop -y &>/dev/null
source .profile
source .bashrc
sleep 1
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"
cd $HOME
rm -rf 0g-storage-node
git clone -b v1.1.0 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
taskset -c 0,1,2 cargo build --release
echo "Репозиторий успешно склонирован, начинаем настройку переменных"
echo "-----------------------------------------------------------------------------"
# Получение приватного ключа
# read -p "Введите private_key (without the `0x` prefix): " PRIVATE_KEY

echo export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log" >> ~/.bash_profile
echo export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config" >> ~/.bash_profile
echo export LOG_CONTRACT_ADDRESS="0xbD75117F80b4E22698D0Cd7612d92BDb8eaff628" >> ~/.bash_profile
echo export MINE_CONTRACT="0x3A0d1d67497Ad770d6f72e7f4B8F0BAbaa2A649C" >> ~/.bash_profile
echo export REWARD_CONTRACT="0xd3D4D91125D76112AE256327410Dd0414Ee08Cb4" >> ~/.bash_profile
source ~/.bash_profile

echo -e "ZGS_LOG_DIR: $ZGS_LOG_DIR\nZGS_LOG_CONFIG_FILE: $ZGS_LOG_CONFIG_FILE\nLOG_CONTRACT_ADDRESS: $LOG_CONTRACT_ADDRESS\nMINE_CONTRACT: $MINE_CONTRACT"

sed -i 's|# network_boot_nodes = \[\]|network_boot_nodes = \["/ip4/47.251.79.83/udp/1234/p2p/16Uiu2HAkvJYQABP1MdvfWfUZUzGLx1sBSDZ2AT92EFKcMCCPVawV", "/ip4/47.238.87.44/udp/1234/p2p/16Uiu2HAmFGsLoajQdEds6tJqsLX7Dg8bYd2HWR4SbpJUut4QXqCj", "/ip4/47.251.78.104/udp/1234/p2p/16Uiu2HAmSe9UWdHrqkn2mKh99b9DwYZZcea6krfidtU3e5tiHiwN", "/ip4/47.76.30.235/udp/1234/p2p/16Uiu2HAm5tCqwGtXJemZqBhJ9JoQxdDgkWYavfCziaqaAYkGDSfU"]|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# blockchain_rpc_endpoint = "http://127.0.0.1:8545"|blockchain_rpc_endpoint = "https://evmrpc-testnet.0g.ai"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_contract_address = ".*"|log_contract_address = "'"$LOG_CONTRACT_ADDRESS"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *log_sync_start_block_number = [0-9]\+|log_sync_start_block_number = 326165|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_config_file = "log_config"|log_config_file = "'"$ZGS_LOG_CONFIG_FILE"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_directory = "log"|log_directory = "'"$ZGS_LOG_DIR"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# mine_contract_address = ".*"|mine_contract_address = "'"$MINE_CONTRACT"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *db_max_num_sectors = [0-9]\+|db_max_num_sectors = 8000000000|' $HOME/0g-storage-node/run/config.toml
sed -i '/# shard_position = "0\/2"/a reward_contract_address = "'"$REWARD_CONTRACT"'"' $HOME/0g-storage-node/run/config.toml
sed -i 's|# batcher_file_capacity = 1|batcher_file_capacity = 10|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# batcher_announcement_capacity = 1|batcher_announcement_capacity = 100|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# auto_sync_enabled = false|auto_sync_enabled = true|' $HOME/0g-storage-node/run/config.toml

sed -i 's|^#\? *network_enr_tcp_port = [0-9]\+|network_enr_tcp_port = 1235|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *network_enr_udp_port = [0-9]\+|network_enr_udp_port = 1235|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *network_libp2p_port = [0-9]\+|network_libp2p_port = 1235|' $HOME/0g-storage-node/run/config.toml
sed -i 's|^#\? *network_discovery_port = [0-9]\+|network_discovery_port = 1235|' $HOME/0g-storage-node/run/config.toml

echo "Переходим к инициализации ноды"
echo "-----------------------------------------------------------------------------"
sudo tee /etc/systemd/system/0g_storage.service > /dev/null <<EOF
[Unit]
Description=0G Storage Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable 0g_storage &>/dev/null
sudo systemctl daemon-reload
sudo systemctl restart 0g_storage

echo "0G Storage Node успешно установлена"
echo "Обязательно запросите токены в кране - https://faucet.0g.ai/"
