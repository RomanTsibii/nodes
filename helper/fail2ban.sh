#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/fail2ban.sh)
# розблокувати
# sudo fail2ban-client set sshd unbanip 115.1.1.21

# Оновлення пакетів та встановлення fail2ban
echo "[+] Оновлення системи та встановлення fail2ban..."
sudo apt update -y && sudo apt install fail2ban -y

# Створення конфігураційного файлу для fail2ban
echo "[+] Налаштування fail2ban..."
cat <<EOF | sudo tee /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
findtime = 600
bantime = 999w
EOF

# Перезапуск fail2ban для застосування змін
echo "[+] Перезапуск fail2ban..."
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Вивід статусу fail2ban
echo "[+] Перевірка статусу fail2ban..."
sudo systemctl status fail2ban --no-pager

# Вивід списку заблокованих IP
echo "[+] Поточні заблоковані IP:"
sudo fail2ban-client status sshd

echo "[✔] Установка та налаштування fail2ban завершено!"
