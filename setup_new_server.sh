#!/bin/bash
set -x
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/setup_new_server.sh)

# оновити час
echo "set Ukraine timezone"
sudo timedatectl set-timezone Europe/Kiev  # old
sudo timedatectl set-timezone Europe/Kyiv  # new

# adds ssh keys
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/add_ssh_keys.sh)

# встановити tmux
# встановити ncdu
sudo apt install ncdu tmux htop screen python3-pip python3-requests -y
sudo pip3 install requests

# добавити свап на 8гб оперативки
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/swap_create.sh) 15
 
# install proxy for adspower
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/proxy_for_antick.sh)
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/proxy_L.sh)
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/proxy_den_alex.sh)

# встановити докер
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
