#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/setup_new_server.sh)

# оновити час
echo "set Ukraine timezone"
sudo timedatectl set-timezone Europe/Kiev
# встановити докер
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)

# встановити tmux
# встановити ncdu
sudo apt install ncdu tmux htop screen -y
 
# install proxy for adspower
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/proxy_for_antick.sh)

# adds ssh keys
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/add_ssh_keys.sh)
