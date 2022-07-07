#!/bin/bash

wget https://github.com/kyve-org/substrate/releases/download/v0.1.3/kyve-linux.zip
unzip kyve-linux.zip 
source $HOME/.profile
rm -rf __MACOSX/ kyve-linux.zip 
chmod u+x kyve-linux 
mv kyve-linux /usr/bin/kyve-Kusama

# запускаем ноду
sudo systemctl daemon-reload && \
sudo systemctl enable kyve-kysama && \
sudo systemctl restart kyve-kysama
  
# проверяем логи
sudo journalctl -u kyve-kysama -f -o cat
