#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/avarage_free_2h.sh)
# set -- 10  # Це задасть $1 значення 10

# blocks=$(curl -s https://mempool.space/testnet/api/v1/blocks | jq '.[0:20]')

# # Ініціалізація змінних для підрахунку
# total_median_fee=0
# block_count=0

# # Обхід кожного блоку для підрахунку medianFee
# for block in $(echo "$blocks" | jq -r '.[] | @base64'); do
#   # Декодування JSON з base64
#   _jq() {
#     echo "${block}" | base64 --decode | jq -r "${1}"
#   }

#   # Витягування medianFee
#   median_fee=$(_jq '.extras.medianFee')

#   # Перевірка, чи medianFee існує і не є null
#   if [[ -n $median_fee && $median_fee != "null" ]]; then
#     total_median_fee=$(echo "$total_median_fee + $median_fee" | bc)
#     block_count=$((block_count + 1))
#   else
#     echo "medianFee для блоку $(_jq '.id') не знайдено або дорівнює null"
#   fi
# done

# # Обчислення середньої medianFee
# if [ $block_count -gt 0 ]; then
#   average_median_fee=$(echo "scale=2; $total_median_fee / $block_count" | bc)
# else
#   average_median_fee=0
# fi



# Округлення значення average_with_percent до цілого числа
# average=$(printf "%.0f\n" "$average_median_fee")
# ----------------------------------------------------
# Максимальна кількість спроб
max_attempts=10
attempt=0
valid=false

while [[ $attempt -lt $max_attempts && $valid == false ]]; do
    # Збільшуємо лічильник спроб
    attempt=$((attempt + 1))

    # Виконуємо запит
    average=$(curl -s https://mempool.space/testnet/api/v1/fees/recommended)

    # Перевіряємо, чи успішно спарсило JSON
    if echo "$average" | jq -e '.hourFee' >/dev/null 2>&1; then
        # Витягуємо значення hourFee
        hour_fee=$(echo "$average" | jq -r '.hourFee')

        # Перевіряємо, чи значення більше або дорівнює 2
        if [[ "$hour_fee" -ge 2 ]]; then
            valid=true
            echo $hour_fee
            break
        fi
    fi

    # Невелика пауза між запитами
    sleep 1
done


# average=$(curl -s https://mempool.space/testnet/api/v1/fees/recommended | jq -r '.hourFee')

# Заміна значення у файлі конфігурації
sudo sed -i "s/Environment=\"POPM_STATIC_FEE=.*/Environment=\"POPM_STATIC_FEE=$hour_fee\"/" /etc/systemd/system/hemi.service

# Перезапуск сервісу
sudo systemctl daemon-reload
sudo systemctl restart hemi.service

# Виведення результатів

echo "Set to hemi FEE average: $hour_fee on $(date '+%Y-%m-%d %H:%M:%S')"
