#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/send_ceremoni_info.sh)

source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}


cer_info=$(pcli ceremony contribute --phase 2 --bid 0penumbra)
cer_info=$(echo $cer_info | grep "for contribution slot from address" | awk '{print $14}')
send_message "Node #Penumbra ceremoni 2. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYour ceremoni address %0A\`$cer_info\`"

