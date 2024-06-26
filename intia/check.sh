#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/check.sh)

# Время ожидания между измерениями (в секундах)
wait_time=60

# Запрос к внешнему API для получения последнего блока
external_block=$(curl -s http://149.102.155.255:50112/ | sed -n 's:.*<p>\(.*\)</p>.*:\1:p')

# Запрос к своей ноде для получения высоты последнего блока
local_block_start=$(curl -s -X GET "http://localhost:25757/abci_info" | jq -r '.result.response.last_block_height')



# Проверка, что оба значения были получены
if [[ -z "$external_block" || -z "$local_block_start" ]]; then
    echo "Не удалось получить значения блоков."
    exit 1
fi

# Ожидание
sleep $wait_time

# Запрос к своей ноде для получения высоты последнего блока после ожидания
local_block_end=$(curl -s -X GET "http://localhost:25757/abci_info" | jq -r '.result.response.last_block_height')

# кількість блоків после ожидания
external_block_end=$(curl -s http://149.102.155.255:50112/ | sed -n 's:.*<p>\(.*\)</p>.*:\1:p')
external=$((external_block_end - external_block))

# Вычисление разницы блоков
blocks_to_catch_up=$((external_block - local_block_end))

# Проверка, что значение разницы блоков положительное
if [[ $blocks_to_catch_up -lt 0 ]]; then
    echo "Ваша нода опережает внешнюю ноду на $((-blocks_to_catch_up)) блоков."
    exit 0
fi

# Вычисление количества синхронизированных блоков за время ожидания
blocks_synced=$((local_block_end - local_block_start))

# Вычисление скорости синхронизации (блоки в секунду)
sync_speed=$(echo "scale=2; $blocks_synced / $wait_time" | bc)

# Вычисление времени до синхронизации в минутах
time_to_sync=$(echo "scale=2; ($blocks_to_catch_up / $sync_speed) / 60" | bc)

echo "Blockchein block now: $external_block"
echo "Blockchein blocks per 60s: $external"
echo "Local blocks node (start): $local_block_start"
echo "Local blocks node (end): $local_block_end"
echo "Syning blocks on node per $wait_time seconds: $blocks_synced"
echo "Speed syning: $sync_speed blocks per second"
echo "Need Syning for catching_up: $blocks_to_catch_up blocks"
echo "Time for full syning: $time_to_sync minutes"

caching_up=$(initiad status | jq | grep "catching_up" | awk '{print $2}')
if $caching_up; then
    
    echo "restart initia"
    # sudo systemctl restart initiad.service
fi


