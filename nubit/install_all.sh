#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/install_all.sh) 


# Базові значення портів
BASE_PORT1=26658
BASE_PORT2=2121

# Кількість контейнерів
NUM_CONTAINERS=2

# Масив з портами
declare -a ports=("26668:26658" "26678:26658" "26688:26658" "26698:26658" "26708:26658" "26718:26658" "26728:26658" "26738:26658" "26748:26658" "26758:26658")
declare -a ports2=("2122:2121"  "2123:2121"   "2124:2121"   "2125:2121"  "2126:2121"    "2127:2121"   "2128:2121"   "2129:2121"   "2130:2121"   "2131:2121")

# Кількість контейнерів
num_containers=10

# Цикл для створення директорій, завантаження Dockerfile, побудови і запуску контейнерів
for ((i=1; i<=num_containers; i++)); do
  # Створення директорії для кожного контейнера
  dir_name="nubit-node-$i"
  mkdir $dir_name && cd $dir_name
  
  # Завантаження Dockerfile
  wget -O Dockerfile https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/nubit/Dockerfile.install
  
  # Побудова Docker image
  docker build --no-cache -t nubit_image .
  
  # Запуск контейнера з унікальними портами
  docker run -d --name nubit-$i --restart always -p ${ports[$i-1]} -p ${ports2[$i-1]} nubit_image
  
  # Вивід логів контейнера
  # docker logs -f --tail=100 nubit-$i
  
  # Копіювання mnemonic.txt та keys з контейнера
  #docker cp nubit-$i:/home/nubit-user/nubit-node/mnemonic.txt $HOME/$dir_name/mnemonic.txt
  #docker cp nubit-$i:/home/nubit-user/.nubit-light-nubit-alphatestnet-1/keys $HOME/$dir_name/keys
  
  # Повернення до початкової директорії
  cd ..
done

echo "Done"
