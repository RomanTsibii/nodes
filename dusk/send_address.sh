#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/dusk/send_address.sh)

source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}


dusk_keys=$(cat $HOME/rusk/dusk/seed.txt)
dusk_address=$(docker compose -f $HOME/rusk/docker-compose.yml run dusk bash -c "/opt/dusk/bin/rusk-wallet --state http://127.0.0.1:8980  --password \$DUSK_CONSENSUS_KEYS_PASS addresses")
send_message "Node #Dusk. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYou keys: %0A\`$dusk_keys\` %0AYou address%0A \`$dusk_address\`"
