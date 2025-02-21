#!/bin/bash

# ===== НАЛАШТУВАННЯ =====
LOG_FILE="/var/log/nexus.log"
PROVER_ID_FILE="/root/.nexus/prover-id"
TIME_INTERVAL=600            # 10 хвилин для перевірки логів
COOLDOWN_INTERVAL=1200       # 20 хвилин (1200 секунд) після перезапуску
INSTALL_URL="https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/screen_install.sh"
CHECKER_LOG="/var/log/nexus_checker.log"
RESTART_TIME_FILE="/tmp/nexus_restart_time"

# ===== ФУНКЦІЇ =====

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$CHECKER_LOG"
}

get_prover_id() {
    if [[ -f "$PROVER_ID_FILE" ]]; then
        cat "$PROVER_ID_FILE"
    else
        log "❗ ERROR: Файл $PROVER_ID_FILE не знайдено!"
        exit 1
    fi
}

check_screen() {
    screen -ls | grep -q "nexus"
}

check_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        last_mod_time=$(stat -c %Y "$LOG_FILE")
        current_time=$(date +%s)
        # Якщо лог не змінювався більше ніж TIME_INTERVAL
        (( current_time - last_mod_time > TIME_INTERVAL )) && return 1 || return 0
    else
        log "❗ ERROR: Файл $LOG_FILE не знайдено!"
        exit 1
    fi
}

restart_nexus() {
    local prover_id
    prover_id=$(get_prover_id)
    log "🔁 Перезапуск Nexus з prover_id=$prover_id"
    screen -S nexus -X quit 2>/dev/null
    curl -s "$INSTALL_URL" | bash -s "$prover_id"
    log "✅ Nexus успішно перезапущено"
    echo $(date +%s) > "$RESTART_TIME_FILE"
}

check_cooldown() {
    if [[ -f "$RESTART_TIME_FILE" ]]; then
        last_restart_time=$(cat "$RESTART_TIME_FILE")
        current_time=$(date +%s)
        if (( current_time - last_restart_time < COOLDOWN_INTERVAL )); then
            log "⏳ Очікування після перезапуску (20 хвилин). Перевірка пропущена."
            exit 0
        fi
    fi
}

# ===== ОСНОВНА ЛОГІКА =====

log "🚀 Запуск чекера Nexus"

# 1. Перевірка часу останнього перезапуску
check_cooldown

# 2. Перевірка screen
if ! check_screen; then
    log "⚠️ Screen-сесія 'nexus' не знайдена. Запуск встановлення..."
    restart_nexus
    exit 0
fi

# 3. Перевірка логів
if ! check_logs; then
    log "⚠️ Логи не змінювались протягом 10 хвилин. Перезапуск..."
    restart_nexus
    exit 0
else
    log "✅ Логи оновлюються. Перезапуск не потрібен."
fi

log "✅ Чекер завершив роботу без помилок"
exit 0
