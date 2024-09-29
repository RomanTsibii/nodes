#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/rivalz/install.sh)
# sudo journalctl -u rivalz.service  -n 80 -f

loop_devices=$(losetup -a | grep "fake_disk.img" | awk -F: '{print $1}')
for loop_device in $loop_devices; do
    sudo losetup -d "$loop_device"
done

cd /root
./config_rivalz.sh
systemctl restart rivalz
echo "journalctl -u rivalz.service -f"
