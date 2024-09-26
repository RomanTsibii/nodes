#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/rivalz/install.sh)
# sudo journalctl -u rivalz.service  -n 20
# 
echo "Enter wallet address"
read EVM_ADDRESS


echo "----Install nodejs----"
sudo apt update && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -  &>/dev/null
sudo apt install -y nodejs expect
npm i -g rivalz-node-cli

echo "----create fake memory----"
echo > fake_disk.img
truncate -s 15T fake_disk.img
sudo losetup -fP fake_disk.img
loop_device=$(losetup -a | grep "fake_disk" | awk -F: '{print $1}')
sudo mkfs.ext4 "$loop_device"
mkdir /mnt/fake_disk
mount -o loop fake_disk.img /mnt/fake_disk
echo "----you fake disk----"
df -h /mnt/fake_disk

DISK_SIZE="14469"

expect << EOF
spawn rivalz run

expect "Enter wallet address (EVM):"
send "$EVM_ADDRESS\r"

expect "Select drive you want to use:"
send "\\033\[A"   
sleep 1
send "\r"         
# sleep 1
expect "Enter Disk size of /dev/loop0 (SSD) you want to use (GB, Max 14469 GB):"
# sleep 3
send "$DISK_SIZE\r"
sleep 5
interact
EOF


sudo bash -c "cat > /etc/systemd/system/rivalz.service" <<EOL
[Unit]
Description=Rivalz Node Service
After=network.target

[Service]
ExecStart=/usr/bin/rivalz run
Restart=always
User=root
WorkingDirectory=/root/.rivalz

[Install]
WantedBy=multi-user.target
EOL

# Оновлення конфігурації systemd
echo "Оновлюємо конфігурацію systemd"
sudo systemctl daemon-reload

# Увімкнення сервісу для автозапуску
echo "Увімкнення сервісу для автозапуску"
sudo systemctl enable rivalz.service

# Запуск сервісу
echo "Запуск сервісу"
echo "sudo systemctl start rivalz.service"

# Перевірка статусу сервісу
echo "Статус сервісу:"
echo "sudo systemctl status rivalz.service"

