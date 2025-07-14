#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/health_check.sh)

# Створюємо директорію для логів
LOG_DIR="/root/gensyn"
mkdir -p "$LOG_DIR"

# Файл для логів
LOG_FILE="$LOG_DIR/health_check.log"

# Функція для логування з датою
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_message "=== Початок виконання health_check.sh ==="

# Видалити кронтаб
log_message "Видалення старих записів з crontab"
crontab -l | grep -v '/root/need_restart.sh' | crontab -

# Змінні
SCRIPT_PATH="/root/need_restart.sh"
SCRIPT_URL="https://raw.githubusercontent.com/RomanTsibii/nodes/main/gensyn/need_restart.sh"

# Завантаження скрипта
log_message "Завантаження скрипта з $SCRIPT_URL"
if wget -q -O "$SCRIPT_PATH" "$SCRIPT_URL"; then
    log_message "Скрипт успішно завантажено"
else
    log_message "ПОМИЛКА: не вдалося завантажити скрипт з $SCRIPT_URL"
    exit 1
fi

# Перевірка, чи скрипт успішно завантажено
if [ ! -f "$SCRIPT_PATH" ]; then
    log_message "ПОМИЛКА: файл скрипта не знайдено після завантаження"
    exit 1
fi

# Надаємо права на виконання
chmod +x "$SCRIPT_PATH"
log_message "Права на виконання надано скрипту"

# Виконання скрипта
log_message "Виконання скрипта need_restart.sh"
if bash "$SCRIPT_PATH" >> "$LOG_FILE" 2>&1; then
    log_message "Скрипт need_restart.sh виконано успішно"
else
    log_message "ПОМИЛКА: при виконанні скрипта need_restart.sh"
fi

# Команда для crontab з логуванням
CRON_CMD="*/5 * * * * bash $SCRIPT_PATH >> $LOG_FILE 2>&1"

# Перевірка наявності SHELL в crontab
if ! crontab -l 2>/dev/null | grep -q '^SHELL=/bin/bash'; then
    (crontab -l 2>/dev/null; echo "SHELL=/bin/bash") | crontab -
    log_message "Додано SHELL=/bin/bash до crontab"
fi

# Перевірка, чи запис вже існує в crontab
if crontab -l 2>/dev/null | grep -Fq "$SCRIPT_PATH"; then
    log_message "Запис вже існує в crontab"
else
    # Додаємо запис до crontab
    (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
    log_message "Запис додано до crontab: $CRON_CMD"
fi

log_message "Поточний crontab:"
crontab -l 2>/dev/null | while read line; do
    log_message "  $line"
done

log_message "=== Завершення виконання health_check.sh ==="
log_message "Логи зберігаються в: $LOG_FILE"

# Показати останні 10 рядків лога
echo ""
echo "Останні записи з лога:"
tail -10 "$LOG_FILE"
