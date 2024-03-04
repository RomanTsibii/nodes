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
INSTALL_PARAMS=$1 # new-all || all || babylon || masa || penumbra || shardeum || elixir || holograph || bevm

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
  echo "Start install Babylon"
  rm -rf /root/.babylond/config/genesis.json
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/babylon/install.sh)"
  peers="49b24d6f0184baf5c378a3377d681cf9aa406cad@144.76.225.220:45656,63b70a09a4a7c7e03b7341ec8550b30badfd0fad@65.21.131.164:45656,90b33ebd5b9e96df19a947518ab65b2a67b69756@109.123.247.218:16456,be517904a7057be2d5eb6a517bc701a529b1f998@62.113.113.14:31656,6cca6ab83027c6d067034704f0192f1a936e97ae@158.220.90.2:16456,bf4ea53535db50eedf02331d8b4c16d33d29a18f@95.217.110.158:45656,4d74fd931b2a31fd4d525e51bd3679323fc10559@34.28.231.106:31156,370c51d2385e83458721fbf615ffbc46bbfd6acf@38.242.239.162:31156,a05b93b6c0179484864db8c6462d1021d2bbf93b@75.119.153.199:16456,a36087bf9bd1d0c34141c99fbbaf3298b057ba53@37.60.229.223:16456,d30ad4db1a1a755f3f5a1df4884fd559d85bacc9@65.109.30.35:16456,adfff08a6e86e0d58dda3f8491cead864d530252@168.119.36.91:45656,26312651733a0f0b31de2080906c152c4fe53ebe@84.247.161.61:31156,8db70e2f39d1b50ec9ecc843c64052c8deaf4bce@88.99.150.206:45656,4b719bf06e46a4f4aa8e6c1742af7038d4d2f3fa@46.4.13.224:45656,1c60cfeb8983dc041a05eb058e85d2867a587ff0@209.97.169.236:16456,9ea89061341983ac0c5eadcd91dd44a7fd054c86@95.217.88.223:45656,1f0181009b2bcb7abefaf4742cabf4c5afef39dd@45.63.29.244:16456,ff74559acf8f529fed40625f05f233eac06c15d8@112.215.242.188:26656,32efc1d96104afdc24eab52b378bb9f1980272f6@95.216.44.225:45656,f49a2428268171b84d778f631f626150b7a7a970@95.216.244.142:45656,c24eefcbb59a2588afb74d0422afc0a8f52f2592@217.76.54.212:16456,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:16456" 
  sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.babylond/config/config.toml
  sudo systemctl restart babylon
  sleep 10
  screen -S install -X stuff "$NODENAME" # set node name
  sleep 1
  screen -S install -X stuff $'\n' # press enter
  wait_for_instaling
  source $HOME/.profile
  # keys_babylon=$(babylond keys add wallet)
  # send_message "Node #Babylon installed. On server *$HOSTNAME* to *$NODE_OWNER*."
  # send_message "You keys *$keys_babylon*"
}

# masa
function masa_install {
  echo "Start install masa"
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/masa/install.sh)"
  wait_for_instaling
  sleep 10
  MASA_PRIVATE=$(cat $HOME/.masa/masa_oracle_key.ecdsa)
  PEER_ID=$(journalctl -u masa | grep "Starting node with ID" | awk -F'/' '{print $NF}' | tr -d '"')
  send_message "Node #Masa installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYour node private *$MASA_PRIVATE* %0APeer id *$PEER_ID*"
}

# penumbra
function penumbra_install {
  echo "Start install penumbra"
  apt update && apt install curl -y
  bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/install_penumbra.sh)
  sleep 1 
  if [[ "$INSTALL_PARAMS" == *"new"* ]]; then
      touch penumbra.txt
      pcli init soft-kms generate >> penymbra.txt
      pcli view address >> penymbra.txt
      pemumbra_keys=$(cat penymbra.txt)
      send_message "Node #Penumbra installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AYou keys *$pemumbra_keys*"
  else
      send_message "Node #Penumbra installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0AImport old memo"
  fi
}

# shardeum
function shardeum_install {
  echo "Start install shardeum"
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
  send_message "Node #Shardeum installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0A"
}

# elixir
function elixir_install {
  echo "Start install elixir"
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
  # send_message "Node Elixir installed. On server *$HOSTNAME* to *$NODE_OWNER*.%0A You can start stake and get role Alchemist(T2)"
}

# holograph
function holograph_install {
  echo "Start install holograph"
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
  echo "Start install bevm"
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/bevm/install.sh)"
  sleep 15
  screen -S install -X stuff "$MM_ADDRESS" # MM_ADDRESS
  sleep 2
  screen -S install -X stuff $'\n' # press enter
  wait_for_instaling
}

function bool_install {
  echo "Start install bool"
  screen -S install -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/boolnetwork/install.sh)"
  sleep 20
  screen -S install -X stuff "$NODENAME" # MM_ADDRESS
  sleep 2
  screen -S install -X stuff $'\n' # press enter
  wait_for_instaling
}

# if [[ $INSTALL_PARAMS == *"masa"*      || $INSTALL_PARAMS == *"all"* ]]; then masa_install      ; fi
# if [[ $INSTALL_PARAMS == *"babylon"*   || $INSTALL_PARAMS == *"all"* ]]; then babylon_install   ; fi
# params all-new,  all, bevm, masa, babylon, penumbra, elixir, holograph, shardeum
if [[ $INSTALL_PARAMS == *"penumbra"*  || $INSTALL_PARAMS == *"all"* ]]; then penumbra_install  ; fi
if [[ $INSTALL_PARAMS == *"bevm"*      || $INSTALL_PARAMS == *"all"* ]]; then bevm_install      ; fi
# if [[ $INSTALL_PARAMS == *"holograph"* || $INSTALL_PARAMS == *"all"* ]]; then holograph_install ; fi
if [[ $INSTALL_PARAMS == *"shardeum"*  || $INSTALL_PARAMS == *"all"* ]]; then shardeum_install  ; fi
if [[ $INSTALL_PARAMS == *"elixir"*    || $INSTALL_PARAMS == *"all"* ]]; then elixir_install    ; fi
# if [[ $INSTALL_PARAMS == *"bool"*      || $INSTALL_PARAMS == *"all"* ]]; then bool_install      ; fi




