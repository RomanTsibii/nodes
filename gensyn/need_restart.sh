#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/need_restart.sh)

LOG_FILE="/root/rl-swarm/logs.log"
MAX_AGE_MINUTES=9

if [ ! -f "$LOG_FILE" ]; then
  echo "Файл $LOG_FILE не існує."
  exit 1
fi

# Отримуємо поточний час та час останньої модифікації файлу в секундах з епохи
CURRENT_TIME=$(date +%s)
FILE_MOD_TIME=$(stat -c %Y "$LOG_FILE")

# Обчислюємо різницю в секундах
TIME_DIFF=$((CURRENT_TIME - FILE_MOD_TIME))

# Перевіряємо останні 5 рядків на наявність повідомлень про помилки
LAST_5_LINES=$(tail -n 5 "$LOG_FILE")
ERROR_PATTERNS=(
  "Shutting down trainer"
  "wandb: Find logs at: ./logs/wandb/offline-run"
)

# Функція для перевірки наявності помилок
check_for_errors() {
  for pattern in "${ERROR_PATTERNS[@]}"; do
    if echo "$LAST_5_LINES" | grep -q "$pattern"; then
      echo "Знайдено повідомлення про помилку: '$pattern'"
      return 0  # Помилка знайдена
    fi
  done
  return 1  # Помилки не знайдено
}

# Перевіряємо, чи файл не змінювався більше ніж MAX_AGE_MINUTES
if [ "$TIME_DIFF" -gt $((MAX_AGE_MINUTES * 60)) ]; then
  echo "Файл $LOG_FILE не змінювався протягом останніх $MAX_AGE_MINUTES хвилин. Виконуємо перезапуск..."
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/restart.sh)
elif check_for_errors; then
  echo "Виконуємо перезапуск через знайдені помилки в логах..."
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/restart.sh)
else
  echo "Файл $LOG_FILE змінювався протягом останніх $MAX_AGE_MINUTES хвилин і помилки не знайдено. Перезапуск не потрібен."
fi
