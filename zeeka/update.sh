#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/zeeka/update.sh)

systemctl stop bazuka
cd bazuka 
git pull origin master 
cargo update 
cargo install --path .

rm -rf ~/.bazuka ~/.bazuka-chaos
cd 
bazuka init --seed '"$BAZUKA_KEY"' --network chaos --node 127.0.0.1:8765

sudo systemctl daemon-reload
sudo systemctl enable bazuka
sudo systemctl restart bazuka

sleep 10
bazuka status
bazuka wallet
echo "sudo journalctl -f -u bazuka -n 100"
