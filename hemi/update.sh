#!/bin/bash


# логи 
# journalctl -n 100 -f -u hemi -o cat
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/update.sh)

# видалити кронтаб
crontab -l | grep -v "/root/scripts/hemi_min_free_2h.sh" | crontab -

systemctl stop hemi

cd $HOME

LATEST_VERSION=$(curl -s https://api.github.com/repos/hemilabs/heminetwork/releases/latest  | grep -oP '"tag_name": "\K(.*?)(?=")')
wget "https://github.com/hemilabs/heminetwork/releases/download/${LATEST_VERSION}/heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz"
tar -xvf "heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz" && rm -f "heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz"

mv -f "$HOME/heminetwork_${LATEST_VERSION}_linux_amd64/"* "$HOME/heminetwork" 
rm -rf "$HOME/heminetwork_${LATEST_VERSION}_linux_amd64"


sudo systemctl daemon-reload
sudo systemctl start hemi

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/crontab.sh)
