#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

if ! command -v curl &> /dev/null; then
  sudo apt update
  sudo apt install -y curl
fi

echo -e "${BLUE}Настраиваем конфигурацию...${NC}"

docker rm -f aztec-sequencer &> /dev/null || true

REAL_USER="${SUDO_USER:-$USER}"
HOME_DIR="$(eval echo "~$REAL_USER")"
EVM_FILE="$HOME_DIR/aztec-sequencer/.evm"
LINE="GOVERNANCE_PROPOSER_PAYLOAD_ADDRESS=0x54F7fe24E349993b363A5Fa1bccdAe2589D5E5Ef"

if [[ ! -f "$EVM_FILE" ]]; then
  echo -e "${RED}Файл не найден:${NC} $EVM_FILE"
  exit 1
fi

if grep -Fxq "$LINE" "$EVM_FILE"; then
  echo -e "${GREEN}Строка уже есть в $EVM_FILE, пропускаем настройку конфигурации!${NC}"
else
  echo -e "${BLUE}Добавляем строку в $EVM_FILE…${NC}"
  printf "\n%s\n" "$LINE" >> "$EVM_FILE"
  echo -e "${GREEN}Настройка успешно завершена!${NC}"
fi

if [ -n "$1" ]; then
  PORT="$1"
  sudo iptables -I INPUT -p tcp --dport 18080 -j ACCEPT

docker run -d \
  --name aztec-sequencer \
  --restart unless-stopped \
  --network host \
  --env-file "$HOME/aztec-sequencer/.evm" \
  -e DATA_DIRECTORY=/data \
  -e LOG_LEVEL=debug \
  -v "$HOME/my-node/node":/data \
  aztecprotocol/aztec:0.85.0-alpha-testnet.8 \
  sh -c "node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
    start --network alpha-testnet --node --archiver --sequencer --port $PORT"
else
docker run -d \
  --name aztec-sequencer \
  --restart unless-stopped \
  --network host \
  --env-file "$HOME/aztec-sequencer/.evm" \
  -e DATA_DIRECTORY=/data \
  -e LOG_LEVEL=debug \
  -v "$HOME/my-node/node":/data \
  aztecprotocol/aztec:0.85.0-alpha-testnet.8 \
  sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js \
    start --network alpha-testnet --node --archiver --sequencer'
fi



echo "docker logs --tail 100 -f aztec-sequencer"
