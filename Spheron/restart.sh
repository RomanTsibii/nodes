#!/bin/bash

# docker-compose -f ~/.spheron/fizz/docker-compose.yml down
# docker-compose -f ~/.spheron/fizz/docker-compose.yml up -d
# sleep 10
# name=$(docker ps --filter "ancestor=spheronnetwork/fizz-node:latest" --format "{{.Names}}")
name=$(docker ps --format "{{.Image}} {{.Names}}" | grep "spheronnetwork" | awk '{print $2}')
# name=fizz-fizz-1
# Поточна кількість ядер
CURRENT_CORES=$(grep -c "^processor" /proc/cpuinfo)

# Загальна кількість ядер (додаємо 32)
# ADDITIONAL_CORES=32
# TOTAL_CORES=$((CURRENT_CORES + ADDITIONAL_CORES))
TOTAL_CORES=32

# Вихідний файл
SOURCE_FILE_CPU="/proc/cpuinfo"
OUTPUT_FILE_CPU="/tmp/fake_cpuinfo"

# Очищаємо файл перед записом
> "$OUTPUT_FILE_CPU"

# Копіюємо всі існуючі ядра
cat "$SOURCE_FILE_CPU" >> "$OUTPUT_FILE_CPU"

# Беремо шаблон останнього ядра
LAST_CORE_TEMPLATE=$(awk '
    /^processor/ {p=1; next}
    p {print}
    /^$/ {exit}
' "$SOURCE_FILE_CPU")

# Перевіряємо, чи знайдено шаблон
if [[ -z "$LAST_CORE_TEMPLATE" ]]; then
    echo "Помилка: не вдалося знайти шаблон для створення ядер."
    exit 1
fi

# Додаємо нові ядра
for ((i=CURRENT_CORES; i<TOTAL_CORES; i++)); do
    echo "processor       : $i" >> "$OUTPUT_FILE_CPU"
    echo "$LAST_CORE_TEMPLATE" | sed \
        -e "s/^core id.*/core id         : $((i % CURRENT_CORES))/" \
        -e "s/^apicid.*/apicid          : $i/" \
        -e "s/^initial apicid.*/initial apicid  : $i/" \
        -e "s/^siblings.*/siblings        : $TOTAL_CORES/" >> "$OUTPUT_FILE_CPU"
    echo "" >> "$OUTPUT_FILE_CPU"
done

echo "Файл з фейковим CPU створено: $OUTPUT_FILE_CPU"

# Копіюємо фейкові дані CPU в контейнер
docker cp /tmp/fake_cpuinfo $name:/root/fake_cpuinfo
docker exec $name sh -c "mount --bind /root/fake_cpuinfo /proc/cpuinfo"

# -------------------------------------------------------------
# Исходный файл
SOURCE_FILE="/proc/stat"
OUTPUT_FILE="/tmp/fake_stat"

# Копируем оригинальные данные
cat "$SOURCE_FILE" > "$OUTPUT_FILE"

# Генерируем фейковые данные для первого cpu и всех отдельных процессоров
# awk '/^cpu[0-9]*/ {
#     $5 = $5 + 100000000  # Увеличиваем idle (пятый столбец)
#     print
# } !/^cpu/ { print }' "$SOURCE_FILE" > "$OUTPUT_FILE"

awk 'BEGIN { srand() } 
/^cpu[0-9]*/ {
    rand_offset = int(100000000 * (0.99 + rand() * 0.1))  # Випадкове число від 99 млн до 101 млн; Увеличиваем idle (пятый столбец)
    $5 = $5 + rand_offset  
    print
} !/^cpu/ { print }' "$SOURCE_FILE" > "$OUTPUT_FILE"

echo "Файл с поддельной нагрузкой создан: $OUTPUT_FILE"

# Монтируем фейковый файл в /proc/stat
docker cp "$OUTPUT_FILE" $name:/root/fake_stat
docker exec $name sh -c "mount --bind /root/fake_stat /proc/stat"

# -------------------------------------------------------------
# Вихідний файл /proc/meminfo
SOURCE_FILE_MEM="/proc/meminfo"
TARGET_FILE_MEM="/tmp/fake_meminfo"

# Додаткове значення у кілобайтах (128 ГБ)
# ADD_VALUE=$((128 * 1024 * 1024))
# генеруємо випадкове число яке буде від 120 до 128 гб оперативки  - значення вказане у кб
ADD_VALUE=$(shuf -i 125829120-134217728 -n 1) 
# Функція для обробки рядків
process_line() {
    local line=$1
    local key=$(echo "$line" | awk '{print $1}')
    local value=$(echo "$line" | awk '{print $2}')
    local unit=$(echo "$line" | awk '{print $3}')
    
    if [[ "$key" == "MemTotal:" || "$key" == "MemFree:" || "$key" == "MemAvailable:" ]]; then
        # value=$((value + ADD_VALUE))
        value=$((ADD_VALUE))
    fi
    
    echo "$key $value $unit"
}

# Перевіряємо, чи існує вихідний файл
if [[ ! -f $SOURCE_FILE_MEM ]]; then
    echo "Файл $SOURCE_FILE_MEM не знайдено."
    exit 1
fi

# Очищаємо цільовий файл
> $TARGET_FILE_MEM

# Обробляємо рядки та записуємо в цільовий файл
while IFS= read -r line; do
    process_line "$line" >> $TARGET_FILE_MEM
done < $SOURCE_FILE_MEM

echo "Файл з фейковою пам'яттю створено: $TARGET_FILE_MEM"

# Копіюємо фейкові дані пам'яті в контейнер
docker cp /tmp/fake_meminfo $name:/root/fake_meminfo
docker exec $name sh -c "mount --bind /root/fake_meminfo /proc/meminfo"
docker exec $name free -h
