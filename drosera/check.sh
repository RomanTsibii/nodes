#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/drosera/check.sh) 

SERVICE="drosera.service"
LOG_KEYWORDS=("Error receiving trap update: Failed to receive trap update from trap watcher: channel closed" "Failed to get next trap update: Failed to receive trap update from trap watcher: channel closed")
RESTART_REQUIRED=false

# Перевірка наявності ключових слів у логах
for keyword in "${LOG_KEYWORDS[@]}"; do
  if journalctl -u "$SERVICE" -n 10 --no-pager | grep -q "$keyword"; then
    echo "🔴 Виявлено помилку: $keyword"
    RESTART_REQUIRED=true
    break
  fi
done

# Перевірка стану служби
if ! systemctl is-active --quiet "$SERVICE"; then
  echo "🔴 Служба $SERVICE неактивна."
  RESTART_REQUIRED=true
fi

# Перезапуск служби, якщо потрібно
if [ "$RESTART_REQUIRED" = true ]; then
  echo "🔄 Перезапуск служби $SERVICE..."
  systemctl restart "$SERVICE"
  sleep 5
  if systemctl is-active --quiet "$SERVICE"; then
    echo "✅ Служба $SERVICE успішно перезапущена."
  else
    echo "❌ Не вдалося перезапустити службу $SERVICE."
  fi
else
  echo "✅ Служба $SERVICE працює стабільно."
fi
