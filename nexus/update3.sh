#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/update3.sh)

echo "🔁 Оновлення всіх nexus-контейнерів..."

# Отримуємо поточний локальний image ID
OLD_IMAGE_ID=$(docker images nexusxyz/nexus-cli:latest --format "{{.ID}}")
echo "🔍 Поточна локальна версія: $OLD_IMAGE_ID"

# Скачуємо останній образ
docker pull nexusxyz/nexus-cli:latest > /dev/null

# Отримуємо новий image ID після pull
NEW_IMAGE_ID=$(docker images nexusxyz/nexus-cli:latest --format "{{.ID}}")
echo "📦 Нова версія образу: $NEW_IMAGE_ID"

# Порівняння
if [ "$OLD_IMAGE_ID" = "$NEW_IMAGE_ID" ]; then
  echo "✅ Образ не змінився — оновлення не потрібне"
else
  echo "♻️ Образ оновлено — перезапускаємо контейнери..."

  for ENV_FILE in /root/nexus/nexus*.env; do
    if [ -f "$ENV_FILE" ]; then
      source "$ENV_FILE"
      CONTAINER_NAME="nexus$INDEX"

      echo "➡️  Перезапуск $CONTAINER_NAME (node-id: $NODE_ID, threads: $MAX_THREADS)..."

      # Видаляємо старий контейнер, якщо існує
      if docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
        docker rm -f "$CONTAINER_NAME"
      fi

      # Запускаємо новий контейнер
      docker run -d \
        --name "$CONTAINER_NAME" \
        --restart unless-stopped \
        nexusxyz/nexus-cli:latest \
        start --node-id "$NODE_ID" --headless --max-threads "$MAX_THREADS"

      echo "✅ $CONTAINER_NAME оновлено."
    fi
  done
fi
