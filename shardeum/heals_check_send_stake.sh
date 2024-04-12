#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/heals_check_send_stake.sh) 


tmux kill-session -t shardeum_healthcheck
tmux new-session -d -s shardeum_healthcheck 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/health.sh)'
sleep 200 
source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

status=$(docker exec -t shardeum-dashboard operator-cli status | grep state | awk '{ print $2 }')
echo $status
function send {
    send_message "Node #Shardeum updated. You need stake *$HOSTNAME*:8080 .%0AYou public key \`$PRIVATE_ADDRESS\`"
    echo "send"
}
if [[ $status == *"need-stake"* ]]; then send ; fi

