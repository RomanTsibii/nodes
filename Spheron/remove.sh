#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Spheron/remove.sh)

docker-compose -f ~/.spheron/fizz/docker-compose.yml down
sudo systemctl stop cheker_spheron.service
sudo systemctl disable cheker_spheron.service
cd; rm -rf .spheron scripts/spheron/
sudo crontab -l | grep -v "@reboot sleep 120; /root/scripts/spheron/restart.sh" | sudo crontab -
sudo crontab -l | grep -v "/bin/bash /root/scripts/spheron/restart.sh" | sudo crontab -
