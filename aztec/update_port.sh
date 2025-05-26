#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/update_port.sh)

docker rm -f aztec-sequencer

sudo iptables -I INPUT -p tcp --dport 18080 -j ACCEPT

docker run -d \
  --name aztec-sequencer \
  --restart unless-stopped \
  --network host \
  --entrypoint /bin/sh \
  --env-file "$HOME/aztec-sequencer/.evm" \
  -e DATA_DIRECTORY=/data \
  -e LOG_LEVEL=debug \
  -v "$HOME/my-node/node":/data \
  aztecprotocol/aztec:0.87.2 \
  -c "node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
   start --network alpha-testnet --node --archiver --sequencer --port 18080"
