#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/verifier.sh) address
# 
# логи
# sudo journalctl -u cysic.service -f

# restart 
# sudo systemctl restart cysic

# stop
# sudo systemctl stop cysic.service

if [ -n "$1" ]; then
  address="$1"
else
  read -p "Enter your address: " address
fi

if [ -d "/root/.cysic/keys/" ]; then
    echo "Існує бекап ноди... видаліть його тут(/root/.cysic) і запустіть ще раз "
    exit
fi

sudo apt update

curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh
bash ~/setup_linux.sh $address

sudo bash -c 'cat > /etc/systemd/system/cysic.service <<EOF
[Unit]
Description=Cysic Verifier Node
After=network.target

[Service]
# Укажите пользователя root
User=root
Group=root

# Установите рабочую директорию
WorkingDirectory=/root/cysic-verifier

# Экспорт переменной окружения и запуск команды
Environment="LD_LIBRARY_PATH=/root/cysic-verifier"
Environment="CHAIN_ID=534352"
ExecStart=/root/cysic-verifier/verifier

# Опции для рестарта
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable cysic.service
sudo systemctl start cysic.service

