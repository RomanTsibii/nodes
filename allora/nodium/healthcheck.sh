#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/healthcheck.sh)
# screen -S allora_healthcheck -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/healthcheck.sh)" 

# Константа для перевірки часу в секундах (40 хвилин)
CHECK_INTERVAL=$((60 * 40))

# Масив з шляхами до docker-compose.yml файлів
DOCKER_COMPOSE_PATHS=(
    "/root/worker3-20m/docker-compose.yml"
    "/root/worker1-10m/docker-compose.yml"
)

# Функція для перевірки логів і перезапуску контейнера
check_and_restart() {
    local compose_file=$1
    local current_time=$(date +%s)

    # Отримуємо останній час із логів у Unix timestamp
    local last_log_time=$(docker compose -f "$compose_file" logs worker | grep "Send Worker Data to chain" | grep txHash | awk -F'"time":' '{split($2, a, ","); print a[1]}' | tail -1)

    if [ -z "$last_log_time" ]; then
        echo "[$(date)] Помилка: Не вдалося знайти час у логах або логи порожні для $compose_file. Перезапускаємо Docker-контейнери..."
        docker compose -f "$compose_file" restart
    elif [ $((current_time - last_log_time)) -gt $CHECK_INTERVAL ]; then
        echo "[$(date)] Не було даних протягом останніх 40 хвилин, перезапускаємо контейнер $compose_file..."
        if ! docker compose -f "$compose_file" restart; then
            echo "[$(date)] Помилка: Не вдалося перезапустити контейнер $compose_file."
        fi
    else
        echo "[$(date)] Дані надходили протягом останніх 40 хвилин, перезапуск не потрібен. $compose_file"
    fi
}

# Вічний цикл
while true; do
    # Перевірка кількості запущених контейнерів
    container_count=$(docker ps | grep allora | wc -l)
    if [ "$container_count" -ne 9 ]; then
        echo "[$(date)] Кількість запущених контейнерів allora не дорівнює 9, перезапускаємо необхідні контейнери..."
        docker compose -f $HOME/worker1-10m/docker-compose.yml restart
        docker compose -f $HOME/worker2-24h/docker-compose.yml restart
        docker compose -f $HOME/worker3-20m/docker-compose.yml restart
    else
        echo "[$(date)] Кількість запущених контейнерів allora дорівнює 9, додатковий перезапуск не потрібен."
    fi

    # Перевірка логів для кожного контейнера
    for compose_file in "${DOCKER_COMPOSE_PATHS[@]}"; do
        check_and_restart "$compose_file"
    done

    # Очікування 10 хвилин перед наступною перевіркою
    sleep 10m
done


