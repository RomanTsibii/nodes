#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/install_full_pack.sh) new 
# screen -S node_setup_all -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/install_full_pack.sh) new "

# NODE_OWNER= >> $HOME/.profile
# NODENAME= >> $HOME/.profile
# BOT_TOKEN= >> $HOME/.profile
# CHAT_ID= >> $HOME/.profile
# PRIVATE_ADDRESS= >> $HOME/.profile
# MM_ADDRESS= >> $HOME/.profile
# NODE_PASSWORD= >> $HOME/.profile # SHARDEUM HOLOGRAHP
NEW_INSTALL=$1 # new || all || node_name

source $HOME/.profile
if [ -z "$NODE_OWNER" ] && [ -z "$NODENAME" ] && [ -z "$BOT_TOKEN" ] && [ -z "$CHAT_ID" ] && [ -z "$PRIVATE_ADDRESS" ] && [ -z "$MM_ADDRESS" ] && [ -z "$NODE_PASSWORD" ]; then
  break
fi

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
  # send_message "Node #Babylon was installed. On server *$HOSTNAME* to *$NODE_OWNER*."
  # send_message "You keys *$keys_babylon*"
}

# masa
function masa_install {
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/masa/install.sh)"
  wait_for_instaling
  sleep 10
  MASA_PRIVATE=$(cat $HOME/.masa/masa_oracle_key.ecdsa)
  send_message "Node #Masa was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYour node private *$MASA_PRIVATE*"
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
      send_message "Node #Penumbra was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYou keys *$pemumbra_keys*"
  else
      send_message "Node #Penumbra was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AImport old memo"
  fi
}

# shardeum
function shardeum_install {
  # add stake variables
  STAKE_SHARDEUM="bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/shardeum/stake.sh) $PRIVATE_ADDRESS $MM_ADDRESS"
  echo 'alias STAKE_SHARDEUM='\'$STAKE_SHARDEUM\' >> $HOME/.profile 
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
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/elixir/install.sh)"
  sleep 15 
  screen -S install -X stuff "$NODENAME" # validator name
  sleep 1
  screen -S install -X stuff $'\n' # press enter
  sleep 5
  screen -S install -X stuff "$MM_ADDRESS" # MM_ADDRESS
  sleep 1
  screen -S install -X stuff $'\n' # press enter
  sleep 5
  screen -S install -X stuff "$PRIVATE_ADDRESS" # PRIVATE_ADDRESS
  sleep 1
  screen -S install -X stuff $'\n' # press enter
  sleep 5
  wait_for_instaling
  # send_message "Node Elixir was installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0A You can start stake and get role Alchemist(T2)"
}

# holograph
function holograph_install {
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh)
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/node.sh)
  npm install -g @holographxyz/cli
  sleep 30
  screen -S install -dm bash -c "holograph config"
  sleep 15
  screen -S install -X stuff $' \e[B \e[B \n' # press space( ), arrow down(\e[B), space, arrow down, space, enter(\n)
  sleep 2
  screen -S install -X stuff $'\n' # goerli - enter
  sleep 2
  screen -S install -X stuff "https://polygon-mumbai-pokt.nodies.app" # polygon RPS
  sleep 2
  screen -S install -X stuff $'\n' # polygon - enter
  sleep 2
  screen -S install -X stuff "https://ava-testnet.public.blastapi.io/ext/bc/C/rpc" # avalanch RPS
  sleep 2
  screen -S install -X stuff $'\n' # polygon - enter
  sleep 2
  screen -S install -X stuff $'\n' # press enter
  sleep 2
  screen -S install -X stuff "$PRIVATE_ADDRESS" # NODE_PASSWORD
  sleep 2
  screen -S install -X stuff $'\n' # press enter
  sleep 3
  screen -S install -X stuff "$NODE_PASSWORD" # NODE_PASSWORD
  sleep 2
  screen -S install -X stuff $'\n' # press enter
}

function bevm_install {
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/bevm/install.sh)"
  sleep 15
  screen -S install -X stuff "$MM_ADDRESS" # MM_ADDRESS
  sleep 2
  screen -S install -X stuff $'\n' # press enter
  wait_for_instaling
}

bevm_install
masa_install
babylon_install
penumbra_install
elixir_install
holograph_install
shardeum_install
