#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_send_publick_code.sh) 

source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

PUBLIC=$(tail -n 1000000 screenlog.0 | grep "public key:"  | awk '{print $11}' | head -1)
send_message "Node #Avail installed. On server *$HOSTNAME* to.%0AYou public key *$PUBLIC*"
