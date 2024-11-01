#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/avarage_free_2h.sh) 10
# set -- 10  # Це задасть $1 значення 10

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

# Перевірка на існування параметра
if [[ -n $1 ]]; then
  # Перевірка, чи є параметр цілим числом
  if [[ $1 =~ ^-?[0-9]+$ ]]; then
    percent=$1
  else
    echo "Введене значення не є цілим числом. Використовується значення за замовчуванням (0%)."
    percent=0
  fi
else
  # Значення за замовчуванням
  percent=0
fi

# Додавання відсотків до average
average_with_percent=$(echo "$average + ($average * $percent / 100)" | bc)

# Округлення значення average_with_percent до цілого числа
average=$(printf "%.0f\n" "$average_with_percent")

# Заміна значення у файлі конфігурації
sudo sed -i "s/Environment=\"POPM_STATIC_FEE=.*/Environment=\"POPM_STATIC_FEE=$average\"/" /etc/systemd/system/hemi.service

# Перезапуск сервісу
sudo systemctl daemon-reload
sudo systemctl restart hemi.service

# Виведення результатів

echo "Set to hemi FEE average: $average on $(date '+%Y-%m-%d %H:%M:%S')"
