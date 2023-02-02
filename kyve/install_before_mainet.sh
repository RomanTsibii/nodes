#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/kyve/install_before_mainet.sh)

read -p "Insert pool for runing: " POOL
read -p "Insert pool name for runing: " POOL_NAME

kysor valaccounts create \
--name "$POOL_NAME" \
--pool "$POOL" \
--storage-priv "$(cat ~/.kysor/arweave.json)" \
--verbose \
--metrics

tee <<EOF > /dev/null /etc/systemd/system/"$POOL_NAME".service
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

echo 'cd ~/.kysor/valaccounts/'
echo 'nano "$POOL_NAME"'
echo 'sudo systemctl daemon-reload && sudo systemctl enable "$POOL_NAME" && sudo systemctl restart "$POOL_NAME"'
echo 'sudo journalctl -u "$POOL_NAME" -f -o cat'


