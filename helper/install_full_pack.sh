#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/install_full_pack.sh) NODE_OWNER 

NODE_OWNER=$1
NODENAME=$2


# sleep if have some install
function wait_for_install {
  while true
  do
    ACTIVE_INSTALATION=$(screen -ls | grep install)
    if [ ! -z "$ACTIVE_INSTALATION" ]; then
          echo "\$var is empty"
          sleep 10
    else
          break
    fi
  done
}

# Telegram send message

HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}
# send_message "My message. Server IP *$HOSTNAME*. "

# babylon

screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/babylon/install.sh)"
sleep 10
screen -S install -X stuff "$NODENAME" # set node name
sleep 1
screen -S install -X stuff $'\n' # press enter
wait_for_install




  echo "You supplied the first parameter!"
else
  echo "First parameter not supplied."


# masa


# penumbra


# shardeum


# elixir


# holograph

