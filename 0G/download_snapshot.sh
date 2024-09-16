#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/download_snapshot.sh)
# Список IP-адрес, записаний через перенесення рядків
ips=(
    188.40.61.176
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

# Виконання wget з підставленою IP-адресою
wget -O storage_0gchain_snapshot.lz4 "http://$random_ip/storage_0gchain_snapshot.lz4"

# Виведення обраної IP-адреси
# echo "Використано IP: $random_ip"
