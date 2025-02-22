#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/remove.sh)

crontab -l | grep -v '/root/nexus_checker.sh' | crontab -
screen -ls | grep "nexus" | awk '{print $1}' | xargs -I {} screen -S {} -X quit
rm -rf /root/.nexus /root/nexus_checker.sh
