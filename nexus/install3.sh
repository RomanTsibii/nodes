#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/install3.sh)

mkdir -p /root/nexus

if [ -n "$1" ]; then
  NODE_ID="$1"
else
  read -p "Введіть NODE_ID: " NODE_ID
fi

if [ -n "$2" ]; then
  MAX_THREADS="$2"
else
  read -p "Введіть кількість потоків (max-threads): " MAX_THREADS
fi

if [ -n "$3" ]; then
  INDEX="$3"
else
  # read -p "Введіть номер контейнера (наприклад: 1 для nexus1): " INDEX
  INDEX=1
fi

ENV_FILE="/root/nexus/nexus$INDEX.env"
CONTAINER_NAME="nexus$INDEX"

echo -e "NODE_ID=$NODE_ID\nMAX_THREADS=$MAX_THREADS\nINDEX=$INDEX" > "$ENV_FILE"

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  nexusxyz/nexus-cli:latest \
  start --node-id "$NODE_ID" --headless --max-threads "$MAX_THREADS"

echo "✅ Контейнер $CONTAINER_NAME запущено і конфігурацію збережено у $ENV_FILE"
