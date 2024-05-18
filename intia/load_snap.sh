#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/load_snap.sh)
# screen -S load_snap_intia -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/load_snap.sh)"

# sudo systemctl stop initia
# cp $HOME.initia/data/priv_validator_state.json $HOME.initia/priv_validator_state.json
# rm -rf $HOME.initia/data/
# curl -L https://snapshots.kjnodes.com/initia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
# systemctl restart initia

sudo systemctl stop initia
cp $HOME.initia/data/priv_validator_state.json $HOME.initia/priv_validator_state.json
rm -rf $HOME.initia/data/
curl -L https://snapshots.polkachu.com/testnet-snapshots/initia/initia_187918.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
systemctl restart initia
