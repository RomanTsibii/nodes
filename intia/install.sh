#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/install.sh)
# screen -S intia_run -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/intia/install.sh)"

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function output {
  echo -e "${YELLOW}$1${NORMAL}"
}

function install_tools {
  sudo apt update
  sudo apt install -y curl git jq lz4 build-essential
}

function get_nodename {
    source $HOME/.profile
    INITIA_NODENAME=$NODENAME
    if [ -z "${INITIA_NODENAME}" ]; then
        echo "Enter your nodename:"
        read INITIA_NODENAME
    fi
    echo 'export INITIA_NODENAME='$INITIA_NODENAME >> $HOME/.profile
}

function install_go {
  sudo rm -rf /usr/local/go
  curl -L https://go.dev/dl/go1.21.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
  source .bash_profile
}

function source_git {
  cd && rm -rf initia
  git clone https://github.com/initia-labs/initia
  cd initia
  git checkout v0.2.14
  make install
}

function cli_configuration {
  initiad config set client chain-id initiation-1
  initiad config set client keyring-backend test
  initiad config set client node tcp://localhost:25757
}

function initialize {
  initiad init "${INITIA_NODENAME}" --chain-id initiation-1
}

function genesis_address {
  curl -L https://snapshots-testnet.nodejumper.io/initia-testnet/genesis.json > $HOME/.initia/config/genesis.json
  curl -L https://snapshots-testnet.nodejumper.io/initia-testnet/addrbook.json > $HOME/.initia/config/addrbook.json
}

function set_seeds {
  sed -i -e 's|^seeds *=.*|seeds = "2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,c28827cb96c14c905b127b92065a3fb4cd77d7f6@testnet-seeds.whispernode.com:25756,cd69bcb00a6ecc1ba2b4a3465de4d4dd3e0a3db1@initia-testnet-seed.itrocket.net:51656,093e1b89a498b6a8760ad2188fbda30a05e4f300@35.240.207.217:26656,2c729d33d22d8cdae6658bed97b3097241ca586c@195.14.6.129:26019"|' $HOME/.initia/config/config.toml
}

function gas_price {
  sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.15uinit,0.01uusdc"|' $HOME/.initia/config/app.toml
}

function puring {
  sed -i \
    -e 's|^pruning *=.*|pruning = "custom"|' \
    -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
    -e 's|^pruning-interval *=.*|pruning-interval = "17"|' \
    $HOME/.initia/config/app.toml
}

function ports {
  sed -i -e "s%:1317%:25717%; s%:8080%:25780%; s%:9090%:25790%; s%:9091%:25791%; s%:8545%:25745%; s%:8546%:25746%; s%:6065%:25765%" $HOME/.initia/config/app.toml
  sed -i -e "s%:26658%:25758%; s%:26657%:25757%; s%:6060%:25760%; s%:26656%:25756%; s%:26660%:25761%" $HOME/.initia/config/config.toml
}

function last_snap {
  curl -L https://snapshots.polkachu.com/testnet-snapshots/initia/initia_187918.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
}

function create_service {
  sudo tee /etc/systemd/system/initiad.service > /dev/null << EOF
[Unit]
Description=Initia node service
After=network-online.target
[Service]
User=$USER
ExecStart=$(which initiad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable initiad.service
}

function main {
    colors
    line
    output "Welcome to the Initia installation script"
    line
    install_tools
    line
    get_nodename
    line
    output "Installing Initia..."
    line
    install_go
    source_git
    cli_configuration
    initialize
    genesis_address
    set_seeds
    gas_price
    puring
    ports
    last_snap
    create_service
    line
    output_normal "Installation complete"
    line
    sudo systemctl start initiad.service
}

main
