#!/bin/bash
# запуск з аргементом(скільки хочеш гб щоб чистило) і без(кожні 10 гб) 
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/ritual/setup_crontab_ritual.sh) 10

# перевірити логи 
# cat $HOME/ritual_GB_restart.log


sudo apt install nano cron -y

# видалити кронтаб на запуск кожні 30 хв
crontab -l | grep -v "ritual_GB_restart.sh" | crontab -

# Перехід до домашньої директорії
cd $HOME

FILE="$HOME/infernet-container-starter/deploy/docker-compose.yaml"

awk '
  # Якщо знайшли "container_name: infernet-anvil", встановлюємо прапорець
  /container_name: infernet-anvil/ { found=1; print; next }

  # Якщо знайдений другий екземпляр "restart: on-failure" після infernet-anvil, пропускаємо його
  found && /restart: on-failure/ && ++count == 2 { found=0; next }

  # Друкуємо всі інші рядки
  { print }
' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

# Встановлюємо дефолтний граничний розмір у 10 ГБ, якщо аргумент не передано
limit_gb=${1:-10}

# Створюємо скрипт ritual_GB_restart.sh
cat <<EOL > ~/ritual_GB_restart.sh
#!/bin/bash

# Додаємо до логів поточну дату та час
echo "---- Виконання скрипта: \$(date) ----" >> ~/ritual_GB_restart.log

# Перевіряємо, чи передано параметр для граничного розміру в GB, і встановлюємо значення за замовчуванням
limit_gb=\${1:-$limit_gb}

# Задаємо граничний розмір у мегабайтах на основі вказаних гігабайтів
limit_mb=\$(echo "\$limit_gb * 1024" | bc)

# Отримуємо розмір контейнера з поля SIZE
size=\$(docker ps --size | grep infernet-anvil | awk -F' ' '{print \$(NF-2)}')

# Перевіряємо, чи розмір контейнера відображається у GB або MB
if [[ "\$size" == *GB ]]; then
    size_in_gb=\$(echo \$size | sed 's/GB//')
    size_in_mb=\$(echo "\$size_in_gb * 1024" | bc)
elif [[ "\$size" == *MB ]]; then
    size_in_mb=\$(echo \$size | sed 's/MB//')
else
    echo "Неможливо визначити розмір контейнера." >> ~/ritual_GB_restart.log
    exit 1
fi

# Якщо розмір більше граничного значення, то виконуємо команди
if (( \$(echo "\$size_in_mb > \$limit_mb" | bc -l) )); then
    echo "Розмір контейнера більше \${limit_gb}GB. Виконуємо перезавантаження..." >> ~/ritual_GB_restart.log
    docker compose -f \$HOME/infernet-container-starter/deploy/docker-compose.yaml down >> ~/ritual_GB_restart.log 2>&1
    docker compose -f \$HOME/infernet-container-starter/deploy/docker-compose.yaml up -d >> ~/ritual_GB_restart.log 2>&1
else
    echo "Розмір контейнера менше \${limit_gb}GB. Перезавантаження не потрібно." >> ~/ritual_GB_restart.log
fi
EOL

# Надаємо права на виконання файлу
chmod +x ~/ritual_GB_restart.sh

# Додаємо cron завдання, щоб запускати скрипт кожні 30 хвилин з переданим аргументом і логами
(crontab -l 2>/dev/null; echo "*/30 * * * * /bin/bash ~/ritual_GB_restart.sh $limit_gb >> ~/ritual_GB_restart.log 2>&1") | crontab -

echo "Скрипт ritual_GB_restart.sh створено і додано до cron для виконання кожні 30 хвилин."

# Запускаємо скрипт одразу після виконання setup_ritual.sh
echo "Запускаємо ritual_GB_restart.sh з аргументом $limit_gb..."
/bin/bash ~/ritual_GB_restart.sh $limit_gb >> ~/ritual_GB_restart.log 
