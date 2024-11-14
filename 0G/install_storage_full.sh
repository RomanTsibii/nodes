#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_full.sh) PRIVATE_KEY RPC
# screen -S 0G_install_stoprage_node -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/install_storage_full.sh) PRIVATE_KEY RPC"
# sudo apt update && sudo apt upgrade -y

if [ -n "$1" ]; then
  PRIVATE_KEY="$1"
else
  read -p "Enter your private key: " PRIVATE_KEY
fi

if [ -n "$2" ]; then
  RPC="$2"
else
  read -p "Enter your RPC: " RPC
fi

echo "Private key: $PRIVATE_KEY"
echo "RPC: $RPC"

cd /root/

echo "Updating package lists..."
sudo apt-get update

echo "Installing necessary packages..."
sudo apt-get install clang cmake build-essential -y

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Removing existing 0g-storage-node directory..."
sudo systemctl stop zgs && rm -r /root/0g-storage-node
sudo systemctl stop 0g && sudo systemctl disable 0g && rm -rf /etc/systemd/system/0g_storage.service

echo "Cloning the repository..."
git clone -b v0.7.4 https://github.com/0glabs/0g-storage-node.git
cd /root/0g-storage-node

echo "Stashing any local changes..."
git stash

echo "Fetching all tags..."
git fetch --all --tags

echo "Checking out specific commit..."
git checkout 4b48d25

echo "Updating submodules..."
git submodule update --init

echo "Building the project..."
cargo build --release

echo "Removing old config file..."
rm -rf /root/0g-storage-node/run/config.toml

echo "Downloading new config file..."
curl -o /root/0g-storage-node/run/config.toml https://raw.githubusercontent.com/zstake-xyz/test/refs/heads/main/0g_storage_config.toml

echo "Creating systemd service file..."
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=/root/0g-storage-node/run
ExecStart=/root/0g-storage-node/target/release/zgs_node --config /root/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sed -i 's|^miner_key = .*|miner_key = "'"$PRIVATE_KEY"'"|' /root/0g-storage-node/run/config.toml
sed -i 's|^blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = "'"$RPC"'"|' /root/0g-storage-node/run/config.toml

echo "Download Snapshot from https://service.josephtran.xyz/testnet/zero-gravity-0g/0g-storage-node/snapshot"
sudo apt-get install wget lz4 aria2 pv -y
aria2c -x 16 -s 16 -k 1M https://josephtran.co/storage_0gchain_snapshot.lz4
lz4 -c -d storage_0gchain_snapshot.lz4 | pv | tar -x -C $HOME/0g-storage-node/run

echo "Reloading systemd daemon, enabling and starting the service..."
sudo systemctl daemon-reload && sudo systemctl enable zgs && sudo systemctl start zgs

echo "0G storege node version"
/root/0g-storage-node/target/release/zgs_node --version
echo "tail -f ~/0g-storage-node/run/log/*"


