#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/change_port.sh)

# Зупиняємо докер старкнету
docker-compose -f $HOME/pathfinder/docker-compose.yml down

# Указываем путь до файла config.json
config_file="$HOME/pathfinder/docker-compose.yml"

# Заменяем URL с помощью команды sed
sed -i 's|- 9545:9545|- 9547:9547|' "$config_file"

# Запускаємо докер старкнету
docker-compose -f $HOME/pathfinder/docker-compose.yml up -d

echo "docker-compose -f $HOME/pathfinder/docker-compose.yml logs -f --tail=50"
