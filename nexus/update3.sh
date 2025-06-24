#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/update3.sh)

echo "🔁 Оновлення всіх nexus-контейнерів..."

docker pull nexusxyz/nexus-cli:latest

for ENV_FILE in /root/nexus/nexus*.env; do
  source "$ENV_FILE"
  CONTAINER_NAME="nexus$INDEX"

  echo "➡️  Перезапуск $CONTAINER_NAME (node-id: $NODE_ID, threads: $MAX_THREADS)..."

  docker rm -f "$CONTAINER_NAME" 2>/dev/null

  docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    nexusxyz/nexus-cli:latest \
    start --node-id "$NODE_ID" --headless --max-threads "$MAX_THREADS"

  echo "✅ $CONTAINER_NAME оновлено."
done
