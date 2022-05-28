# cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/ironfish_crontab.sh > ironfish_crontab.sh && chmod +x ironfish_crontab.sh && ./ironfish_crontab.sh

# file ironfish_restart_every_hour.sh

sudo bash -c 'cat << EOF > /root/ironfish_restart_every_hour.sh
STATUS=\`docker exec ironfish ./bin/run status\`
if [[ "\$STATUS" == *"SYNCING"* ]]; then 
  cd ~/
  docker-compose restart
fi
EOF'

chmod +x ironfish_restart_every_hour.s
(crontab -l 2>/dev/null || true; echo "5 * * * * /root/ironfish_restart_every_hour.sh") | crontab -
