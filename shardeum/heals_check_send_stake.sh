#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/heals_check_send_stake.sh) 

# cd $HOME/.shardeum && ./docker-up.sh
# cd $HOME

tmux kill-session -t shardeum_healthcheck
tmux new-session -d -s shardeum_healthcheck 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/health.sh)'
sleep 100 

# info for TG
source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

# get info from shardeum
status=$(docker exec -t shardeum-dashboard operator-cli status | grep state | awk '{ print $2 }')
echo $status

function need_up {
    send_message "Node #Shardeum. i just up docker for \`$HOSTNAME\`"
    echo "send only up"
    cd $HOME/.shardeum && ./docker-up.sh
    sleep 500
    status=$(docker exec -t shardeum-dashboard operator-cli status | grep state | awk '{ print $2 }')
}
if  [ -n "$status" ];; then need_up ; fi # send info to TG when up docker

function need_stake_send {
    send_message "Node #Shardeum. You need stake *$HOSTNAME*:8080 .%0AYou public key \`$PRIVATE_ADDRESS\`%0AAddress: \`$MM_ADDRESS\`"
    echo "send need stake"
}
if [[ $status == *"need-stake"* ]]; then need_stake_send ; fi # send info to TG if need stake




