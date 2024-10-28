#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/avarage_free_2h.sh)

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

# Заміна значення у файлі конфігурації
sudo sed -i "s/Environment=\"POPM_STATIC_FEE=.*/Environment=\"POPM_STATIC_FEE=$average\"/" /etc/systemd/system/hemi.service

# Перезапуск сервісу
sudo systemctl daemon-reload
sudo systemctl restart hemi.service

# Виведення результатів

echo "Average of total fees: $average"
