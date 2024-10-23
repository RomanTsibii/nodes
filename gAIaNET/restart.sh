#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/restart.sh)
# tail -f /var/log/bot_gaia.log
# tail -f /var/log/bot_gaia.log
# 
# nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &       # start
# kill $(ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}')   # stop

# stop
kill $(ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}')   # stop
/root/gaianet/bin/gaianet stop

# rebild
/root/gaianet/bin/gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

# start
/root/gaianet/bin/gaianet run
sleep 10
nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &       # start
