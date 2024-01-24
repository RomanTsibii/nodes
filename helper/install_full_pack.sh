#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/install_full_pack.sh) new 

NODE_OWNER= >> $HOME/.profile
NODENAME= >> $HOME/.profile
BOT_TOKEN=6979653862:AAG5JsLzasCedd23d5M_6MNIq6Y0Ec3n_xk >> $HOME/.profile
CHAT_ID=351645047 >> $HOME/.profile
PRIVATE_ADDRESS= >> $HOME/.profile
MM_ADDRESS= >> $HOME/.profile
NODE_PASSWORD= >> $HOME/.profile # SHARDEUM 
NEW_INSTALL=$1

# sleep if have some install
function wait_for_instaling {
  while true
  do
    ACTIVE_INSTALATION=$(screen -ls | grep install)
    if [ ! -z "$ACTIVE_INSTALATION" ]; then
          echo "Installing node"
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

# Babylon indstall
function babylon_install {
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/babylon/install.sh)"
  sleep 10
  screen -S install -X stuff "$NODENAME" # set node name
  sleep 1
  screen -S install -X stuff $'\n' # press enter
  wait_for_instaling
  source $HOME/.profile
  # keys_babylon=$(babylond keys add wallet)
  send_message "Node Babylon was installed. On server *$HOSTNAME* to *$NODE_OWNER*."
  # send_message "You keys *$keys_babylon*"
}

# masa
function masa_install {
  
}

# penumbra
function penumbra_install {
  apt update && apt install curl -y
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/install_penumbra.sh)
  sleep 1 
  if [ "$NEW_INSTALL" = "new" ]; then
      touch penumbra.txt
      pcli init soft-kms generate >> penymbra.txt
      pcli view address >> penymbra.txt
      pemumbra_keys=$(cat penymbra.txt)
      send_message "Node Penumbra was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYou keys *$pemumbra_keys*"
  else
      send_message "Node Penumbra was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AImport old memo"
  fi
}

# shardeum
function shardeum_install {
  screen -S install -dm bash -c ". <(wget -qO- sh.doubletop.io) shardeum install"
  sleep 30
  screen -S install -X stuff $'\n' # press enter: INSTALL?
  sleep 30
  screen -S install -X stuff $'\n' # press enter: collect this data. (Y/n)
  sleep 3
  screen -S install -X stuff $'\n' # press enter: (default ~/.shardeum)
  sleep 3
  screen -S install -X stuff $'\n' # press enter: dashbord
  sleep 3
  screen -S install -X stuff "$NODE_PASSWORD"
  sleep 3
  screen -S install -X stuff $'\n' # press enter: PASSWORD
  sleep 1
  screen -S install -X stuff $'\n' # press enter: (default 8080)
  sleep 1
  screen -S install -X stuff $'\n' # press enter: (default=auto)
  sleep 1
  screen -S install -X stuff $'\n' # press enter:(default=auto)
  sleep 1
  screen -S install -X stuff $'\n' # press enter: default 9001)
  sleep 1
  screen -S install -X stuff $'\n' # press enter: (default 10001)
  sleep 2400
  screen -S install -X stuff $'\n' # press enter: node installed
  # wait_for_instaling
  
  

  
}

# elixir
function elixir_install {
  
}

# holograph
function holograph_install {
  
}
