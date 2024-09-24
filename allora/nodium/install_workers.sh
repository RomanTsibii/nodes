#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/install_workers.sh)

echo "Enter seed "
read WALLET_SEED_PHRASE

echo "Enter RPC "
read RPC

cd $HOME
docker compose -f $HOME/allora-huggingface-walkthrough/docker-compose.yaml down -v
docker compose -f $HOME/worker1-10m/docker-compose.yml down
docker compose -f $HOME/worker2-24h/docker-compose.yml down
docker compose -f $HOME/worker3-20m/docker-compose.yml down
rm -rf worker1-10m/ worker2-24h/ worker3-20m/

rm -rf basic-coin-prediction-node


echo "------------- install 1 worker -------------"
git clone https://github.com/nhunamit/basic-coin-prediction-node.git
mv basic-coin-prediction-node worker1-10m
cd worker1-10m
git checkout worker1-10m
# git branch -a 
sed -i "/\"nodeRpc\"/ s|\"nodeRpc\": \".*\"|\"nodeRpc\": \"$RPC\"|" config.json
sed -i "/\"addressRestoreMnemonic\"/ s|\"addressRestoreMnemonic\": \".*\"|\"addressRestoreMnemonic\": \"$WALLET_SEED_PHRASE\"|" config.json

# jq --arg rpc "$RPC" '.wallet.nodeRpc = $rpc' config.json > tmp.json && mv tmp.json config.json
# jq --arg seed "$WALLET_SEED_PHRASE" '.wallet.addressRestoreMnemonic = $seed' config.json > tmp.json && mv tmp.json config.json

./init.config
docker compose build
docker compose up -d
cd ..

echo "------------- install 2 worker -------------"
git clone https://github.com/nhunamit/basic-coin-prediction-node.git
mv basic-coin-prediction-node worker2-24h
cd worker2-24h
git checkout worker2-24h
# git branch -a
jq --arg rpc "$RPC" '.wallet.nodeRpc = $rpc' config.json > tmp.json && mv tmp.json config.json
jq --arg seed "$WALLET_SEED_PHRASE" '.wallet.addressRestoreMnemonic = $seed' config.json > tmp.json && mv tmp.json config.json
# sed -i "s|just clap slim ...|$WALLET_SEED_PHRASE|" config.json
./init.config
# docker compose build
# docker compose up -d
cd ..

echo "------------- install 3 worker -------------"
git clone https://github.com/nhunamit/basic-coin-prediction-node.git 
mv basic-coin-prediction-node worker3-20m
cd worker3-20m
git checkout worker3-20m
# git branch -a
jq --arg rpc "$RPC" '.wallet.nodeRpc = $rpc' config.json > tmp.json && mv tmp.json config.json
jq --arg seed "$WALLET_SEED_PHRASE" '.wallet.addressRestoreMnemonic = $seed' config.json > tmp.json && mv tmp.json config.json
./init.config
docker compose build
docker compose up -d
cd ..


echo "docker compose -f $HOME/worker1-10m/docker-compose.yml logs -f -n 10"
echo "docker compose -f $HOME/worker2-24h/docker-compose.yml logs -f -n 10"
echo "docker compose -f $HOME/worker3-20m/docker-compose.yml logs -f -n 10"
