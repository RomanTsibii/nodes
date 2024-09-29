#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/rivalz/restart.sh)
# sudo journalctl -u rivalz.service  -n 80 -f

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

cd /root
./config_rivalz.sh
systemctl start rivalz
echo "journalctl -u rivalz.service -f"
