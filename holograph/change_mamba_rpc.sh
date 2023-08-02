#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/holograph/change_mamba_rpc.sh)
# Указываем путь до файла config.json
config_file="$HOME/.config/holograph/config.json"

# Заменяем URL с помощью команды sed
sed -i 's|"providerUrl": "https://rpc-mumbai.maticvigil.com"|"providerUrl": "https://rpc.ankr.com/polygon_mumbai"|' "$config_file"

echo "Замена выполнена успешно."
