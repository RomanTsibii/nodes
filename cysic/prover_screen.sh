#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/cysic/prover_screen.sh) address
# 
# логи
# tail -f /root/cysic-prover/logs.log

# restart 
# sudo systemctl restart cysic-prover

# stop

# start

if [ -n "$1" ]; then
  address="$1"
else
  read -p "Enter your address: " address
fi

SCREEN_NAME=cysic
COMMAND="bash start.sh"
LOG_FILE="$HOME/cysic-prover/logs.log"

cd
apt-get install htop screen -y

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update

apt update
# apt install -y supervisor
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda-repo-ubuntu2204-12-6-local_12.6.3-560.35.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-6-local_12.6.3-560.35.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-6-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-6
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_prover.sh >  ~/setup_prover.sh
chmod +x setup_prover.sh
bash ~/setup_prover.sh $address
rm -rf cuda-repo*

if screen -list | grep -q "$SCREEN_NAME"; then
  echo "Сесія $SCREEN_NAME вже існує. Закриття..."
  screen -ls | grep "$SCREEN_NAME" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
fi

cd ~/cysic-prover/
# Створення скрипта з коректною підстановкою змінної
wget -O "$HOME/cysic-prover/${SCREEN_NAME}_start.sh" https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/helper/restart_always.sh
sed -i "s|COMMAND=\"[^\"]*\"|COMMAND=\"$COMMAND\"|" "${SCREEN_NAME}_start.sh"

chmod u+x "${SCREEN_NAME}_start.sh"

# 2 запустити у ньому у фоні файл
sleep 1
echo "restart $SCREEN_NAME" 
screen -dmS "$SCREEN_NAME" -L
sleep 1
screen -S "$SCREEN_NAME" -X logfile "$LOG_FILE"
screen -S "$SCREEN_NAME" -X log on
sleep 1
screen -S "$SCREEN_NAME" -X stuff "bash ${SCREEN_NAME}_start.sh"
sleep 1
screen -S "$SCREEN_NAME" -X stuff $'\n' # press enter

sleep 20
# journalctl -u cysic-prover 

echo "DONE"
echo "Logs: tail -f /root/cysic-prover/logs.log"
