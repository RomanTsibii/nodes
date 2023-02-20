#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/kyve/install_before_mainet.sh)

read -p "Insert pool for runing: " POOL
read -p "Insert pool name for runing: " POOL_NAME
read -p "Insert servise file name: " SERVISE
SER_POOL_NAME=POOL_NAME | awk {print$0}

kysor valaccounts create \
--name "$POOL_NAME" \
--pool "$POOL" \
--storage-priv "$(cat ~/.kysor/arweave.json)" \
--metrics

tee <<EOF > /dev/null /etc/systemd/system/$SERVISE.service
[Unit]
Description=KYVE Protocol
After=network-online.target
[Service]
User=$USER
ExecStart=$(which kysor) start --valaccount "$POOL_NAME"
Restart=always
RestartSec=3
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF

echo cd ~/.kysor/valaccounts/
echo nano $SERVISE
echo "sudo systemctl daemon-reload && sudo systemctl enable $SERVISE && sudo systemctl restart $SERVISE"
echo sudo journalctl -u $SERVISE -f -o cat


