#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hemi/remove.sh)

systemctl stop hemi; systemctl disable hemi
rm -rf /root/heminetwork /root/scripts/hemi_min_free_2h.sh  /root/scripts/hemi_min_free_2h.log
crontab -l | grep -v "/root/scripts/hemi_min_free_2h.sh" | crontab -
