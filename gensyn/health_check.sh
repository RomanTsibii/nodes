#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/health_check.sh)
# видалити кронтаб
# crontab -l | grep -v '/root/need_restart.sh' | crontab -
# 
SCRIPT_PATH="/root/need_restart.sh"
SCRIPT_URL="https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/need_restart.sh"

# Завантаження скрипта
wget -q -O "$SCRIPT_PATH" "$SCRIPT_URL"

# Перевірка, чи скрипт успішно завантажено
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Помилка: не вдалося завантажити скрипт з $SCRIPT_URL"
  exit 1
fi

# Надаємо права на виконання
chmod +x "$SCRIPT_PATH"

# Виконання скрипта
bash "$SCRIPT_PATH"

# Команда для crontab
CRON_CMD="* * * * * bash $SCRIPT_PATH"

# Перевірка, чи запис вже існує в crontab
(crontab -l 2>/dev/null | grep -Fq "$CRON_CMD") || (
  # Додаємо запис до crontab
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Запис додано до crontab."
)
