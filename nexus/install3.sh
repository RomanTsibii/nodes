#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/install3.sh)

mkdir -p /root/nexus

# 🔹 Збір аргументів
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
  INDEX=1
fi

function install_docker {
    if ! type "docker" > /dev/null; then
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
    fi
}

install_docker

ENV_FILE="/root/nexus/nexus$INDEX.env"
CONTAINER_NAME="nexus$INDEX"

# 🔥 Видалення існуючого контейнера, якщо є
if docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
  echo "⚠️ Контейнер $CONTAINER_NAME вже існує — видаляємо..."
  docker rm -f "$CONTAINER_NAME"
fi

# 💾 Збереження конфігу
echo -e "NODE_ID=$NODE_ID\nMAX_THREADS=$MAX_THREADS\nINDEX=$INDEX" > "$ENV_FILE"

# 🚀 Запуск нового контейнера
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  nexusxyz/nexus-cli:latest \
  start --node-id "$NODE_ID" --headless --max-threads "$MAX_THREADS"

echo "✅ Контейнер $CONTAINER_NAME запущено і конфігурацію збережено у $ENV_FILE"

