#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/send_tg_wallet.sh) 

source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

sleep 1
screen -dmS 0G_wallet -L
sleep 2
screen -S 0G_wallet -X colon "logfile flush 0^M"  
sleep 2
screen -S 0G_wallet -X stuff "evmosd keys add wallet"
sleep 5
screen -S 0G_wallet -X stuff $'\n' # press enter
sleep 3
screen -S 0G_wallet -X stuff "$NODE_PASSWORD"
sleep 3
screen -S 0G_wallet -X stuff $'\n' # press enter
sleep 3
screen -S 0G_wallet -X stuff "$NODE_PASSWORD"
sleep 3
screen -S 0G_wallet -X stuff $'\n' # press enter
sleep 2

seed=$(tail -n 30 screenlog.0 | grep -A2 "you ever forget your password" | tail -n 1)
wallet=$(tail -n 30 screenlog.0 | grep address | awk '{print $3}')
send_message "Node #0G wallet. On server \`$HOSTNAME\` to.%0AYou seed \`$seed\`%0AAddress: \`$wallet\`"
