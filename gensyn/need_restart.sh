#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/need_restart.sh)

LOG_FILE="/root/rl-swarm/logs.log"
MAX_AGE_MINUTES=16

if [ ! -f "$LOG_FILE" ]; then
  echo "Файл $LOG_FILE не існує."
  exit 1
fi

# Отримуємо поточний час та час останньої модифікації файлу в секундах з епохи
CURRENT_TIME=$(date +%s)
FILE_MOD_TIME=$(stat -c %Y "$LOG_FILE")

# Обчислюємо різницю в секундах
TIME_DIFF=$((CURRENT_TIME - FILE_MOD_TIME))

# Перевіряємо, чи файл не змінювався більше ніж MAX_AGE_MINUTES
if [ "$TIME_DIFF" -gt $((MAX_AGE_MINUTES * 60)) ]; then
  echo "Файл $LOG_FILE не змінювався протягом останніх $MAX_AGE_MINUTES хвилин. Виконуємо перезапуск..."
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/restart.sh)
else
  echo "Файл $LOG_FILE змінювався протягом останніх $MAX_AGE_MINUTES хвилин. Перезапуск не потрібен."
fi
