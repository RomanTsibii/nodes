#!/bin/bash


# логи 
# tail -n 50 /root/scripts/hemi_min_free_2h.log
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/crontab.sh)
# видалити кронтаб
crontab -l | grep -v "/root/scripts/hemi_min_free_2h.sh" | crontab -

# Створюємо папку scripts, якщо її не існує
mkdir -p /root/scripts

# Скачуємо файл і перейменовуємо його
# curl -o /root/scripts/hemi_min_free_2h.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/min_free_2h.sh

curl -o /root/scripts/hemi_min_free_2h.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/avarage_free_2h.sh

# Надаємо права на виконання файлу
chmod +x /root/scripts/hemi_min_free_2h.sh

# Додаємо завдання в crontab для запуску кожні 2 години на випадковій хвилині
# Випадкове число від 0 до 59 для хвилин
minute=$((RANDOM % 60))

# Записуємо завдання в crontab

if [ -n "$1" ]; then
  max_fee="$1"
  (crontab -l 2>/dev/null; echo "$minute */1 * * * /root/scripts/hemi_min_free_2h.sh \"$max_fee\" >> /root/scripts/hemi_min_free_2h.log 2>&1") | crontab -
  /root/scripts/hemi_min_free_2h.sh "$max_fee" >> /root/scripts/hemi_min_free_2h.log
else
  (crontab -l 2>/dev/null; echo "$minute */1 * * * /root/scripts/hemi_min_free_2h.sh >> /root/scripts/hemi_min_free_2h.log 2>&1") | crontab -
  /root/scripts/hemi_min_free_2h.sh >> /root/scripts/hemi_min_free_2h.log
fi
