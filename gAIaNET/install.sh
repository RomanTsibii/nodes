#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/gAIaNET/install.sh)
# tail -f /var/log/bot_gaia.log
# tail -f /var/log/bot_gaia.log
# 
# nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &       # start
# kill $(ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}')   # stop
#
sudo crontab -l | grep -v "@reboot /root/gaianet/bin/gaianet run >> /var/log/gaianet.log 2>&1 && /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &" | sudo crontab -

kill $(ps aux | grep bot_gaia.sh | grep -v grep | awk '{print $2}')   # stop
/root/gaianet/bin/gaianet stop 
cd /root
sudo apt update -y 
# sudo apt-get update
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
# curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/download/0.4.7/install.sh' | bash


source ~/.bashrc
/root/gaianet/bin/gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json
# /root/gaianet/bin/gaianet config --port 48070
echo "Starts node..."
# gaia_run=$(/root/gaianet/bin/gaianet run | tee /dev/tty)
# gaia_url=$(echo "$gaia_run" | grep -o 'https://[a-zA-Z0-9.-]\+')

attempts=0
# Цикл на 5 спроб
while [[ $attempts -lt 5 ]]; do
    # Збільшуємо лічильник спроб
    ((attempts++))

    # Запуск команди і запис результату
    gaia_run=$(/root/gaianet/bin/gaianet run | tee /dev/tty)

    # Витягуємо gaia_url
    gaia_url=$(echo "$gaia_run" | grep -o 'https://[a-zA-Z0-9.-]\+')

    # Перевірка, чи gaia_url не порожній
    if [[ -n "$gaia_url" ]]; then
        echo "Gaia URL найден: $gaia_url"
        break  # Виходимо з циклу, якщо gaia_url знайдений
    fi

    # Якщо gaia_url не знайдений, чекаємо 5 секунд
    echo "Gaia URL не найден, попытка $attempts из 5..."
    sleep 5
done

if [[ -z "$gaia_url" ]]; then
    echo "Gaia URL не найден: $gaia_url"
    exit
fi

if [[ -z "$gaia_url" ]]; then
    echo "Gaia URL не найден: $gaia_url"
    exit 1  # Завершаем выполнение скрипта с ошибкой
fi

sleep 20
gaianet_info=$(/root/gaianet/bin/gaianet info)
gaia_url=$(echo "$gaia_run" | grep -o 'https://[a-zA-Z0-9.-]\+')
Node_ID=$(echo "$gaianet_info" | awk -F 'Node ID: ' '{print $2}' | awk '{print $1}')
Device_ID=$(echo "$gaianet_info" | awk -F 'Device ID: ' '{print $2}')

echo "Node_ID: $Node_ID"
echo "Device_ID: $Device_ID"
echo "gaia url: $gaia_url"

# gaianet stop

cd /root/gaianet 
wget -O phrases.txt https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/phrases.txt
wget -O bot_config.json https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_config.json
wget -O bot_gaia.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/bot_gaia.sh
wget -O start.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/gAIaNET/start.sh

chmod +x bot_gaia.sh
chmod +x start.sh

# Якщо gaia_url не існує, використовуємо Node_ID
# jq --arg node_id "$Node_ID" '.url = "https://\($node_id).us.gaianet.network/v1/chat/completions"' bot_config.json > temp.json && mv temp.json bot_config.json
# sed -i 's/\\u001b\[0m//g' bot_config.json

# Якщо gaia_url існує, використовуємо його
jq --arg gaia_url "$gaia_url" '.url = "\($gaia_url)/v1/chat/completions"' bot_config.json > temp.json && mv temp.json bot_config.json

(sudo crontab -l ; echo "@reboot /root/gaianet/bin/gaianet run >> /var/log/gaianet.log 2>&1 && /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &") | sudo crontab -
nohup /root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &   # start
/root/gaianet/bin/gaianet info
