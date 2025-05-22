#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/drosera/crontab.sh)
# видалити кронтаб
crontab -l | grep -v '/root/scripts/drosera_check.sh' | crontab -
# 
SCRIPT_PATH="/root/scripts/drosera_check.sh"
SCRIPT_URL="https://raw.githubusercontent.com/RomanTsibii/nodes/main/drosera/check.sh"
SCRIPT_LOG="/root/scripts/drosera_check.log"

cd
mkdir -p scripts && cd scripts

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
CRON_CMD="*/5 * * * * bash $SCRIPT_PATH >> $SCRIPT_LOG"

if ! crontab -l 2>/dev/null | grep -q '^SHELL=/bin/bash'; then
    (crontab -l 2>/dev/null; echo "SHELL=/bin/bash") | crontab -
fi

# Перевірка, чи запис вже існує в crontab
(crontab -l 2>/dev/null | grep -Fq "$CRON_CMD") || (
  # Додаємо запис до crontab
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Запис додано до crontab."
)
