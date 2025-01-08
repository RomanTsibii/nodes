#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/remove.sh)

systemctl stop zgs.service  
systemctl disable zgs.service

systemctl stop 0g_storage
systemctl disable 0g_storage
rm -rf 0g-storage-node/
rm -rf storage_0gchain_snapshot*
