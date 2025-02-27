#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/update.sh)
# 
# логи
# docker-compose -f ~/.spheron/fizz/docker-compose.yml logs  -f
# видалити кронтаб 
sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
sudo crontab -l | grep -v "/bin/bash /root/scripts/spheron/restart.sh" | sudo crontab -

mkdir -p scripts/spheron && cd scripts/spheron
wget -O restart.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/restart.sh
chmod +x restart.sh

sudo curl -o /etc/systemd/system/cheker_spheron.service https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/Spheron/cheker_spheron.service
# sudo chmod 644 /etc/systemd/system/cheker_spheron.service
# sudo chown root:root /etc/systemd/system/cheker_spheron.service

sudo systemctl daemon-reload
sudo systemctl enable cheker_spheron.service
sudo systemctl start cheker_spheron.service
sudo systemctl restart cheker_spheron.service

docker-compose -f ~/.spheron/fizz/docker-compose.yml down
docker-compose -f ~/.spheron/fizz/docker-compose.yml up -d

# ./restart.sh

# (sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
# RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */3 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -


