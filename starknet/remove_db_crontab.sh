#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/remove_db_crontab.sh)


cat << EOF > /root/starknet_remove_db.sh
#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/starknet_remove_db.sh)
EOF

(crontab -u $USER -l ; echo "*/5 * * * * perl /root/starknet_remove_db.sh") | crontab -u $USER -

BYTES=$(du -s $HOME/pathfinder/pathfinder | awk '{print$1}')

if ((YTES > 53687091 ]; then
   echo "remove starknet DB"
    
fi

# remove crontab
# crontab -u $USER -l | grep -v 'starknet_remove_db.sh' | crontab -u $USER -
