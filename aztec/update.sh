#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/update.sh) 18080
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Обновлення ноди Aztec...${NC}"
docker pull aztecprotocol/aztec:0.87.2

docker rm -f aztec-sequencer

rm -rf "$HOME/my-node/node/"*
           
if [ -n "$1" ]; then
  PORT="$1"
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
   start --network alpha-testnet --node --archiver --sequencer --port $PORT"
else
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
  -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
    start --network alpha-testnet --node --archiver --sequencer'
fi


# Завершающий вывод
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
echo -e "${YELLOW}Команда для перевірки логів:${NC}" 
echo "docker logs --tail 100 -f aztec-sequencer"
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"

