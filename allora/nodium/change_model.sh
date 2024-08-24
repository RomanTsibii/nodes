#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/change_model.sh)
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/nodium/change_model.sh) linear_BayesianRidge
# https://github.com/RomanTsibii/allora_models/tree/main - всі моделі 

# зупинка контейнерів
docker compose -f $HOME/worker1-10m/docker-compose.yml down -v
docker compose -f $HOME/worker2-24h/docker-compose.yml down -v
docker compose -f $HOME/worker3-20m/docker-compose.yml down -v 

# видалити всі контейнери з алорою 
docker ps -a | grep allora | awk '{print $1}' | xargs docker rm -f

# видалити всі images з алорою 
docker images | grep worker | awk '{print $3}' | xargs docker rmi -f

# видалити всі network з алорою 
docker network rm worker1-10m_default worker2-24h_default worker3-20m_default

# видалити всі volume з алорою 
docker volume prune -f


# Клонування репозиторію
source_dir="$HOME/allora_models"
cd $HOME/
git clone https://github.com/RomanTsibii/allora_models.git

my_model="${1}.py" 

# Перевірка, чи існує модель з назвою $my_model
if [ -n "$my_model" ] && [ -f "$source_dir/$my_model" ]; then
    model="$my_model"
else
    model=$(ls "$source_dir" | shuf -n 1)
fi

# Копіювання вибраної моделі
cp "$source_dir/$model" "$HOME/worker1-10m/model.py"
cp "$source_dir/$model" "$HOME/worker2-24h/model.py"
cp "$source_dir/$model" "$HOME/worker3-20m/model.py"

rm -rf $HOME/allora_models/
# запуск контейнерів
docker compose -f $HOME/worker1-10m/docker-compose.yml up -d --build
docker compose -f $HOME/worker2-24h/docker-compose.yml up -d --build
docker compose -f $HOME/worker3-20m/docker-compose.yml up -d --build
