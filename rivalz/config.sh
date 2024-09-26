#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/rivalz/config.sh)

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
spawn rivalz change-hardware-config
expect "Select drive you want to use:"
send "\\033\[A"
send "\r"
sleep 1

expect "Enter Disk size of /dev/loop0 (SSD) you want to use (GB, Max 14469 GB):"
send "$DISK_SIZE\r"
sleep 5

interact
EOF
