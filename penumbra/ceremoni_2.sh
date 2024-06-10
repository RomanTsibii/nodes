#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/stake.sh)
# screen -S node_setup_all -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/ceremoni_2.sh) tokens"



balance=$(pcli view balance | grep "penumbra " | awk '{print $3}' | sed 's/penumbra//')
balance_number=$(echo $balance | awk '{print $1 + 0}') # Конвертуємо у числове значення

# Згенерувати випадкове число від 5 до 50
random_number=$(shuf -i 5-50 -n 1)

# Відняти випадкове число від балансу
new_balance=$((balance_number - random_number))

# добавляємо до числового значення 
new_balance_with_suffix="${new_balance}penumbra"

echo $new_balance_with_suffix
# запустити церемонію 
pcli ceremony contribute --phase 2 --bid new_balance_with_suffix

