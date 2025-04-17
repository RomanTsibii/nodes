#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/tea/deploy.sh) MM_PRIV

# Отримати значення MM_PRIV
if [ -n "$1" ]; then
  MM_PRIV="$1"
else
  read -p "Enter your MM_PRIV: " MM_PRIV
fi

# Шлях до конфігураційного файлу
CONFIG_FILE="/root/my-hardhat-project/hardhat.config.js"

# Екранувати лапки для sed
ESCAPED_PRIV=$(printf '%s\n' "$MM_PRIV" | sed 's/[\/&]/\\&/g')

# Замінити accounts значення у файлі
sed -i -E "s/accounts: \[[^]]+\]/accounts: [\"$ESCAPED_PRIV\"]/" "$CONFIG_FILE"

# Запустити деплой
cd /root/my-hardhat-project && npx hardhat run scripts/deploy.js --network sepolia
