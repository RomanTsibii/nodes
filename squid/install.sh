#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/install.sh)

npm install --global @subsquid/cli@latest
sqd --version

sqd init my-cryptopunks-squid -t https://github.com/subsquid-quests/cryptopunks-squid
sqd init my-ens-squid -t https://github.com/subsquid-quests/ens-squid
git clone https://github.com/subsquid-quests/simple-busd-subgraph

