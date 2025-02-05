#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/install.sh) ГБ

free -h

if [ -n "$1" ]; then
  swap_GB="$1"
else
  read -p "Введіть скільки ГБ ви хочете використовувати під свапи: (наприклад 4 чи 6)" swap_GB
fi

# видалити якщо вже існує свап файл
# Перевірка, чи використовується swap-файл
if sudo swapon --show | grep -q '/swapfile'; then
    echo "Swap file /swapfile is active. Disabling it..."
    sudo swapoff /swapfile
else
    echo "Swap file /swapfile is not active."
fi

# Видалення рядка з /etc/fstab
if grep -q '/swapfile none swap sw 0 0' /etc/fstab; then
    echo "Removing swap file entry from /etc/fstab..."
    sudo sed -i '/\/swapfile none swap sw 0 0/d' /etc/fstab
else
    echo "No swap file entry found in /etc/fstab."
fi

sudo swapon --show
free -h
sudo fallocate -l 6G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
