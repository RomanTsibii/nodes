#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/zeeka/update.sh)

sudo systemctl stop bazuka
sudo systemctl disable bazuka
cd bazuka 
git pull origin master 
cargo install --path .
rm ~/.bazuka.yaml

if [ -z $ZEEKA_MEMO ]; then
        read -p "Inset you mnemonic: " ZEEKA_MEMO
        echo 'export ZEEKA_MEMO='$ZEEKA_MEMO >> $HOME/.profile
fi
echo 'You mnemonic: ' $ZEEKA_MEMO

if [ -z $ZEEKA_DISCORD ]; then
        read -p "Inset you discord: " ZEEKA_DISCORD
        echo 'export ZEEKA_DISCORD='$ZEEKA_DISCORD >> $HOME/.profile
fi
echo 'You discord: ' $ZEEKA_DISCORD

bazuka init --mnemonic "$ZEEKA_MEMO" --network groth --bootstrap 23.34.12.45:8765 --bootstrap 34.56.78.23:8765

cd
rm -rf /etc/systemd/system/bazuka.service


printf "[Unit]
Description=Zeeka node
After=network.target

[Service]
User=$USER
ExecStart=`RUST_LOG=info which bazuka` node start --discord-handle \"$DISCORD_HANDLE\"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/zeekad.service


sudo systemctl daemon-reload && sudo systemctl enable zeekad
sudo systemctl restart zeekad

sleep 10
sudo journalctl -fn 100 -u zeekad

#echo 'bazuka status'
#echo 'bazuka wallet'
#echo "sudo journalctl -fn 100 -u zeekad"
#echo DONE
