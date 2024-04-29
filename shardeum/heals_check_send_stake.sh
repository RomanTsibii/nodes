#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/heals_check_send_stake.sh) 

cd $HOME/.shardeum && ./docker-up.sh
cd $HOME

tmux kill-session -t shardeum_healthcheck
tmux new-session -d -s shardeum_healthcheck 'bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/shardeum/health.sh)'
sleep 100 
source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

status=$(docker exec -t shardeum-dashboard operator-cli status | grep state | awk '{ print $2 }')
echo $status
function need_stake_send {
    send_message "Node #Shardeum updated. You need stake *$HOSTNAME*:8080 .%0AYou public key \`$PRIVATE_ADDRESS\`%0AAddress: \`$MM_ADDRESS\`"
    echo "send"
}
if [[ $status == *"need-stake"* ]]; then need_stake_send ; fi

function need_up {
    send_message "Node #Shardeum updated. You need stake \`$HOSTNAME\`"
    echo "send"
}

until [[ $status == *"need-stake"* ]] ||  [[ $status == *"active"* ]] || [[ $status == *"waiting-for-network"* ]] || [[ $status == *"standby"* ]] || [[ $status == *"stopped"* ]] || 
do
     need_up
done
