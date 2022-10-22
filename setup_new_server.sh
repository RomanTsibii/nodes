#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/setup_new_server.sh)

# оновити час
echo "set Ukraine timezone"
sudo timedatectl set-timezone Europe/Kiev
# встановити докер

# встановити tmux
# встановити ncdu
sudo apt install ncdu tmux -y
sudo apt install htop -y
