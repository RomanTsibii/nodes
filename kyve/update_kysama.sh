#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kyve/update_kysama.sh)


# wget https://github.com/kyve-org/substrate/releases/download/v0.3.1/kyve-linux.zip
wget https://github.com/kyve-org/substrate/releases/download/v0.3.0/kyve-linux.zip
unzip kyve-linux.zip 
source $HOME/.profile
rm -rf __MACOSX/ kyve-linux.zip 
chmod u+x kyve-linux 
mv kyve-linux /usr/bin/kyve-Kusama

# запускаем ноду
sudo systemctl daemon-reload && \
sudo systemctl enable kyve-kysama && \
sudo systemctl restart kyve-kysama

sleep 10
  
# проверяем логи
sudo journalctl -u kyve-kysama -f -o cat
