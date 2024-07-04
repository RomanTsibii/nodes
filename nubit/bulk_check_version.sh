#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/bulk_check_version.sh)

# Виконати команду docker exec і зберегти результат
output=$(docker exec -it nubit /home/nubit-user/nubit-node/bin/nubit version)

# Перевірити наявність потрібного тексту в результаті
if [[ "$output" == *"Semantic version: v0.1.0-rc.2-39-ga7b2879-dev"* ]]; then
    echo "Текст знайдено! в контейнері nubit"
else
    echo "Текст не знайдено! в контейнері nubit"
fi


for i in {1..10}
do
    # Виконати команду docker exec для кожного контейнера
    output=$(docker exec -it nubit-$i /home/nubit-user/nubit-node/bin/nubit version)

    # Перевірити наявність потрібного тексту в результаті
    if [[ "$output" == *"Semantic version: v0.1.0-rc.2-39-ga7b2879-dev"* ]]; then
        echo "Текст знайдено в контейнері nubit-$i!"
    else
        echo "Текст не знайдено в контейнері nubit-$i."
    fi
done
