#!/bin/bash
# видалити кронтаб
# crontab -l | grep -v '/root/nexus_checker.sh' | crontab -

# 1. Завантаження скрипта у каталог /root
curl -o /root/nexus_checker.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/nexus/nexus_checker.sh

# 2. Дозвіл на виконання скрипта
chmod +x /root/nexus_checker.sh

# 3. Додавання cron-запису (кожні 10 хвилин)
(crontab -l 2>/dev/null; echo "*/10 * * * * /root/nexus_checker.sh >> /var/log/nexus_checker.log 2>&1") | crontab -
