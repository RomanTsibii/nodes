#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/multiple/install.sh) IDENTIFIER  PIN

if [ -n "$1" ]; then
  IDENTIFIER="$1"
else
  read -p "Введите ваш Account ID:" IDENTIFIER
fi

if [ -n "$2" ]; then
  PIN="$2"
else
  read -p "Установите ваш PIN:" PIN
fi

# echo -e "Введите ваш Account ID:"
# read IDENTIFIER
# echo -e "Установите ваш PIN:"
# read PIN

echo "Установка проекта"

curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="http://162.55.95.49/multipleforlinux.tar"
    # CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="http://162.55.95.49/multipleforlinux2.tar"
    # CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "Неподдерживаемая архитектура системы: $ARCH"
    exit 1
fi

wget $CLIENT_URL -O multipleforlinux.tar

tar -xvf multipleforlinux.tar
rm -rf multipleforlinux.tar

cd multipleforlinux
chmod +x ./multiple-cli
chmod +x ./multiple-node

echo "PATH=\$PATH:$(pwd)" >> $HOME/.bash_profile
source $HOME/.bash_profile

sudo tee /etc/systemd/system/multiple.service > /dev/null << EOF
[Unit]
Description=Multiple Network node client on a Linux Operating System
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/multipleforlinux/multiple-node
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable multiple
sudo systemctl start multiple

echo "-----------------------------------------------------------------------"
echo "Привязка аккаунта"
echo "-----------------------------------------------------------------------"

# ./multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFIER --pin $PIN --storage 200 --bandwidth-upload 100
# ./multiple-cli bind --bandwidth-download 3000 --identifier $IDENTIFIER --pin $PIN --storage 50000 --bandwidth-upload 1000
sleep 80
min=1500000  # 1.5 GB
max=3000000  # 3 GB
step=100000  # 100 MB
steps=$(( (max - min) / step ))
random_step=$(( RANDOM % (steps + 1) ))
random_size=$(( min + random_step * step ))
echo "Випадковий розмір: $random_size KB"

while true; do
    # OUTPUT=$(./multiple-cli bind --bandwidth-download 3000 --identifier $IDENTIFIER --pin $PIN --storage 50000 --bandwidth-upload 1000 2>&1)
    OUTPUT=$(./multiple-cli bind --bandwidth-download 1000 --identifier $IDENTIFIER --pin $PIN --storage $random_size --bandwidth-upload 1000 2>&1)
    
    echo "$OUTPUT"
    
    if echo "$OUTPUT" | grep -q "Node binding successful"; then
        echo "Node binding successful, exiting..."
        break
    elif echo "$OUTPUT" | grep -q "Node not bound"; then
        echo "Error encountered: Node data read exception. Retrying in 10 seconds..."
        sleep 10
    else
        echo "Unexpected output, exiting..."
        break
    fi
done

$HOME/multipleforlinux/multiple-cli status
echo "-----------------------------------------------------------------------"
echo -e "Команда для проверки статуса ноды:"
echo -e "\$HOME/multipleforlinux/multiple-cli status"
echo "-----------------------------------------------------------------------------"
echo "DOUBLETOP SCAM"
echo "-----------------------------------------------------------------------------"
