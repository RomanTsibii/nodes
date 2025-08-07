#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aztec/update_rps.sh) sepolia beacon

if [ -n "$1" ]; then
  SEPOLIA="$1"
else
  read -p "Enter your SEPOLIA_RPC: " SEPOLIA
fi

if [ -n "$2" ]; then
  BEACON="$2"
else
  read -p "Enter your BEACON_SEPOLIA_RPC: " BEACON
fi

# Перевіряємо чи введені значення не пусті
if [ -z "$SEPOLIA" ] || [ -z "$BEACON" ]; then
    echo "Помилка: RPC адреси не можуть бути пустими!"
    exit 1
fi

# Шлях до файлу
FILE_PATH="/root/aztec-sequencer/.evm"

# Замінюємо змінні за допомогою sed
sed -i "s|^ETHEREUM_HOSTS=.*|ETHEREUM_HOSTS=$SEPOLIA|" "$FILE_PATH"
sed -i "s|^L1_CONSENSUS_HOST_URLS=.*|L1_CONSENSUS_HOST_URLS=$BEACON|" "$FILE_PATH"

