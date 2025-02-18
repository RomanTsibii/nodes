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

sudo bash -c 'cat > /etc/systemd/system/cheker_spheron.service <<EOF
[Unit]
Description=Відстеження запуску контейнера fizz та виконання скрипта
After=docker.service
Wants=docker.service

[Service]
Type=simple
ExecStart=/bin/bash -c '"'"'
  docker events --filter container=fizz-fizz-1 --filter event=start | while read event; do
    echo "Container fizz-fizz-1 started, waiting for full startup..."
    while [ "$(docker inspect -f \"{{.State.Running}}\" fizz-fizz-1)" != "true" ]; do
      sleep 5
    done
    echo "Container fizz-fizz-1 is fully running, executing script..."
    /bin/bash /root/scripts/spheron/restart.sh
  done
'"'"'
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

systemctl daemon-reload
systemctl enable docker-container-watcher
systemctl start docker-container-watcher

docker-compose -f ~/.spheron/fizz/docker-compose.yml down
docker-compose -f ~/.spheron/fizz/docker-compose.yml up -d

# ./restart.sh

# (sudo crontab -l ; echo "@reboot sleep 120;/bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -
# RANDOM_MIN=$((RANDOM % 60));(sudo crontab -l ; echo "$RANDOM_MIN */3 * * * /bin/bash /root/scripts/spheron/restart.sh") | sudo crontab -


