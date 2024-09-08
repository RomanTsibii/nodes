#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_node.sh)
# screen -S 0G_run -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_node.sh)"


if [ -n "$1" ]; then
  PRIVATE_KEY="$1"
else
  read -p "Enter your private key: " PRIVATE_KEY
fi

echo "Private key: $PRIVATE_KEY"


sudo apt update && sleep 1 
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh | bash &>/dev/null
sudo apt install curl tar cargo cpulimit wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool cmake -y && sleep 1 
sudo apt install jq -y

# maybe need install rust 


cd $HOME
git clone -b v0.4.6 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init

# cargo build --release
# cpulimit --limit=50 -- cargo build --release
taskset -c 0,1 cargo build --release


sudo cp $HOME/0g-storage-node/target/release/zgs_node /usr/local/bin
cd $HOME


echo 'export NETWORK_LISTEN_ADDRESS="$(wget -qO- eth0.me)"' >> ~/.bash_profile
echo 'export BLOCKCHAIN_RPC_ENDPOINT="https://archive-0g.josephtran.xyz"' >> ~/.bash_profile
source ~/.bash_profile

sed -i '
s|^\s*#\s*network_dir = "network"|network_dir = "network"|
s|^\s*#\s*rpc_enabled = true|rpc_enabled = true|
s|^\s*#\s*network_listen_address = "0.0.0.0"|network_listen_address = "'"$NETWORK_LISTEN_ADDRESS"'"|
s|^\s*#\s*network_libp2p_port = 1234|network_libp2p_port = 1234|
s|^\s*#\s*network_discovery_port = 1234|network_discovery_port = 1234|
s|^\s*#\s*blockchain_rpc_endpoint = "http://127.0.0.1:8545"|blockchain_rpc_endpoint = "'"$BLOCKCHAIN_RPC_ENDPOINT"'"|
s|^\s*#\s*log_contract_address = ""|log_contract_address = "0xbD2C3F0E65eDF5582141C35969d66e34629cC768"|
s|^\s*#\s*log_sync_start_block_number = 0|log_sync_start_block_number = 595059|
s|^\s*#\s*rpc_listen_address = "0.0.0.0:5678"|rpc_listen_address = "0.0.0.0:5678"|
s|^\s*#\s*mine_contract_address = ""|mine_contract_address = "0x6815F41019255e00D6F34aAB8397a6Af5b6D806f"|
s|^\s*#\s*miner_key = ""|miner_key = ""|
' $HOME/0g-storage-node/run/config.toml

sed -i 's|^miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml

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
MemoryMax=1G

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl restart zgs
sleep 5m


# -----------------  shapshot -----------------
sudo systemctl stop zgs
sudo apt-get update
sudo apt-get install wget lz4 aria2 pv -y

aria2c -x5 -s4 https://vps5.josephtran.xyz/0g/storage_0gchain_snapshot.lz4
lz4 -c -d storage_0gchain_snapshot.lz4 | pv | tar -x -C $HOME/0g-storage-node/run
sudo systemctl restart zgs && sudo systemctl status zgs

cd 
rm -rf storage_0gchain_snapshot.lz4



