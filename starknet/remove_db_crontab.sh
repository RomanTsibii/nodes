#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/remove_db_crontab.sh)


cat << EOF > /root/starknet_remove_db_crontab.sh
#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/for_crontab.sh)
EOF

chmod u+x starknet_remove_db_crontab.sh
(crontab -u $USER -l ; echo "0 3 * * * /root/starknet_remove_db_crontab.sh") | crontab -u $USER -

# remove crontab
# crontab -u $USER -l | grep -v 'starknet_remove_db.sh' | crontab -u $USER -
