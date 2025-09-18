#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/update.sh) 0.87.7 18080
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ -n "$1" ]; then
  VERSION="$1"
else
  read -p "Enter your VERSION: " VERSION
fi

echo -e "${BLUE}Обновлення ноди Aztec...${NC}"
docker pull aztecprotocol/aztec:$VERSION

docker rm -f aztec-sequencer

rm -rf "$HOME/my-node/node/"*
           
if [ -n "$2" ]; then
  PORT="$2"
  sudo iptables -I INPUT -p tcp --dport $PORT -j ACCEPT

docker run -d \
  --name aztec-sequencer \
  --restart unless-stopped \
  --network host \
  --entrypoint /bin/sh \
  --env-file "$HOME/aztec-sequencer/.evm" \
  -e DATA_DIRECTORY=/data \
  -e LOG_LEVEL=info \
  -v "$HOME/my-node/node":/data \
  aztecprotocol/aztec:$VERSION \
  -c "node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
   start --network testnet --node --archiver --sequencer --port $PORT"
else
docker run -d \
  --name aztec-sequencer \
  --restart unless-stopped \
  --network host \
  --entrypoint /bin/sh \
  --env-file "$HOME/aztec-sequencer/.evm" \
  -e DATA_DIRECTORY=/data \
  -e LOG_LEVEL=info \
  -v "$HOME/my-node/node":/data \
  aztecprotocol/aztec:$VERSION \
  -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
    start --network testnet --node --archiver --sequencer'
fi


# Завершающий вывод
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
echo -e "${YELLOW}Команда для перевірки логів:${NC}" 
echo "docker logs --tail 100 -f aztec-sequencer"
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"

