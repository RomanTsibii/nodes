#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/rivalz/install.sh)
# sudo journalctl -u rivalz.service  -n 80 -f
# 
echo "Enter wallet address"
read EVM_ADDRESS

### remove old if exists
systemctl stop rivalz
mount_point="/mnt/fake_disk"
image_file="fake_disk.img"

if mountpoint -q "$mount_point"; then
    sudo umount "$mount_point"
fi

loop_device=$(losetup -a | grep "$image_file" | awk -F: '{print $1}')

if [ -n "$loop_device" ]; then
    sudo losetup -d "$loop_device"
fi

if [ -f "$image_file" ]; then
    rm "$image_file"
fi

loop_devices=$(losetup -a | grep "fake_disk.img" | awk -F: '{print $1}')
for loop_device in $loop_devices; do
    sudo losetup -d "$loop_device"
done



### install
echo "----Install nodejs----"
# Отключаем интерактивный режим и устанавливаем необходимые пакеты
export DEBIAN_FRONTEND=noninteractive

# Установка пакетов с подавлением интерактивных запросов
sudo apt update -y # -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &>/dev/null
sudo apt install -y nodejs  # expect -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

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
sleep 3
send "$DISK_SIZE\r"
sleep 5
interact
EOF

cd /root
wget -O config_rivalz.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/rivalz/config.sh
chmod +x config_rivalz.sh


sudo bash -c "cat > /etc/systemd/system/rivalz.service" <<EOL
[Unit]
Description=Rivalz Node Service
After=network.target

[Service]
ExecStartPre=-/bin/bash -c '[ ! -f /tmp/rivalz_initialized ] && /bin/bash /root/config_rivalz.sh && touch /tmp/rivalz_initialized'
ExecStart=/usr/bin/rivalz run
Restart=always
User=root
WorkingDirectory=/root/.rivalz

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload

sudo systemctl enable rivalz.service

sudo systemctl start rivalz.service

# Перевірка статусу сервісу
echo "Wail 20sec info status:"
sleep 20
rivalz info

echo "Chech Logs:"
echo "sudo journalctl -u rivalz.service  -n 80 -f"

# sudo systemctl status rivalz.service
