#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/download_snapshot.sh)
# Список IP-адрес, записаний через перенесення рядків
# 188.40.61.176
cd $HOME
FILE="storage_0gchain_snapshot.lz4"
# MIN_SIZE=16985884
# MAX_SIZE=16986084
file_valid=false

# Перевірка наявності файлу та його розміру
# if [ -f "$FILE" ]; then
#     # Отримуємо розмір файлу через du -s
#     FILE_SIZE=$(du -s "$FILE" | cut -f1)
    
#     # Перевіряємо, чи знаходиться розмір файлу у потрібному діапазоні
#     if [ "$FILE_SIZE" -ge "$MIN_SIZE" ] && [ "$FILE_SIZE" -le "$MAX_SIZE" ]; then
#         echo "Файл існує і його розмір в межах заданого діапазону."
#         file_valid=true
#     else
#         echo "Файл існує, але його розмір не підходить."
#     fi
# else
#     echo "Файл не існує."
# fi

# Якщо файл не валідний, завантажуємо його
if [ "$file_valid" = false ]; then
    ips=(
        161.97.84.217
        84.247.135.34
        161.97.97.252
        144.91.67.42
        84.247.134.40
        149.102.128.152
        149.102.148.207
        149.102.128.162
        149.102.129.107
        149.102.155.255
    )

    # Отримання випадкової IP-адреси
    random_ip=${ips[$RANDOM % ${#ips[@]}]}

    # Завантаження файлу через wget
    echo "Завантажую файл з http://$random_ip/storage_0gchain_snapshot.lz4"
    wget -O "$FILE" "http://$random_ip/storage_0gchain_snapshot.lz4"
fi

# Розпаковка та перезапуск служби
sudo apt-get install wget lz4 aria2 pv -y &>/dev/null
rm -rf $HOME/0g-storage-node/run/{db,log,network}
lz4 -c -d storage_0gchain_snapshot.lz4 | pv | tar -x -C $HOME/0g-storage-node/run
sudo systemctl restart zgs.service &>/dev/null
# sudo systemctl restart 0g_storage &>/dev/null

echo "tail -f ~/0g-storage-node/run/log/*"
echo "DONE"
