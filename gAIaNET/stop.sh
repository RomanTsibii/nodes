#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/stop.sh)

# Зупиняємо всі процеси, пов'язані з gaianet
gaianet stop

ps aux | grep gaianet | grep -v grep | awk '{print $2}' | while read -r pid; do
    kill "$pid"
done

# Зупиняємо всі процеси, пов'язані з bot_gaia.sh
ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}' | while read -r pid; do
    kill "$pid"
done
echo "ps aux | grep gaianet"
echo "ps aux | grep bot_gaia.sh"
