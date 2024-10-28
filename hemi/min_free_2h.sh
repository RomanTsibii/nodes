#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/min_free_2h.sh)

# Витягнення значень total_fee в масив
total_fees=$(curl -s https://mempool.space/testnet/api/v1/statistics/2h | jq '.[].total_fee')

# Обчислення суми
sum=0
count=0

for fee in $total_fees; do
    sum=$((sum + fee))
    count=$((count + 1))
done

# Знаходження середнього значення
if [ $count -ne 0 ]; then
    average=$((sum / count))
    average=$((average / 100000000))  # Ділимо на 100000000
else
    average=0
fi

min_fee=9999999999999  # Ініціалізуємо з дуже великим значенням

for fee in $total_fees; do
    if [ "$fee" -lt "$min_fee" ]; then
        min_fee=$fee
    fi
done

# Ділимо на 100000000 для отримання бажаного формату
min_fee=$((min_fee / 100000000))
mid_value=$(( (min_fee + average) / 2 ))

# Заміна значення у файлі конфігурації
sudo sed -i "s/Environment=\"POPM_STATIC_FEE=.*/Environment=\"POPM_STATIC_FEE=$mid_value\"/" /etc/systemd/system/hemi.service

# Перезапуск сервісу
sudo systemctl daemon-reload
sudo systemctl restart hemi.service

# Виведення результатів
echo "Мінімальне значення: $min_fee"
echo "Average of total fees: $average"
echo "Середнє значення між мінімальним і середнім: $mid_value"
