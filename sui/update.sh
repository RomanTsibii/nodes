#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/sui/update.sh)


systemctl stop suid; \
rm -rf $HOME/.sui/db; \
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob; \
systemctl restart suid
echo DONE
