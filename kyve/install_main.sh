
#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"
if [ ! $KYVE_NODENAME ]; then
	read -p "Введите ваше имя ноды(придумайте, без спецсимволов - только буквы и цифры): " KYVE_NODENAME
fi
sleep 1
KYVE_CHAIN="kyve-1"
echo 'export KYVE_CHAIN='$KYVE_CHAIN >> $HOME/.profile
echo 'export KYVE_NODENAME='$KYVE_NODENAME >> $HOME/.profile
echo "-----------------------------------------------------------------------------"
echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"
sudo apt update && sudo apt upgrade -y
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/go.sh | bash &>/dev/null
sudo apt install --fix-broken -y &>/dev/null
sudo apt install nano mc wget build-essential git jq make gcc tmux chrony lz4 unzip ncdu htop -y &>/dev/null
source .profile
source .bashrc
sleep 1
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"
cd $HOME
wget https://github.com/KYVENetwork/chain/releases/download/v1.0.0/kyved_linux_amd64.tar.gz
tar -xvzf kyved_linux_amd64.tar.gz &>/dev/null
sudo chmod +x kyved
mkdir -p $HOME/go/bin
sudo mv kyved $HOME/go/bin/kyved
rm kyved_linux_amd64.tar.gz
echo "Репозиторий успешно склонирован, начинаем билд"
echo "-----------------------------------------------------------------------------"
kyved config chain-id $KYVE_CHAIN
kyved config keyring-backend file
kyved init $KYVE_NODENAME --chain-id $KYVE_CHAIN &>/dev/null
wget -O $HOME/.kyve/config/genesis.json wget https://files.kyve.network/mainnet/genesis.json
wget -qO $HOME/.kyve/config/addrbook.json https://raw.githubusercontent.com/RomanTsibii/nodes/main/kyve/addrbook.json
sed -i -e "s%^moniker *=.*%moniker = \"$KYVE_NODENAME\"%; "\
"s%^external_address *=.*%external_address = \"`wget -qO- eth0.me`:26656\"%; " $HOME/.kyve/config/config.toml
SEEDS=""
PEERS="b950b6b08f7a6d5c3e068fcd263802b336ffe047@18.198.182.214:26656,25da6253fc8740893277630461eb34c2e4daf545@3.76.244.30:26656,146d27829fd240e0e4672700514e9835cb6fdd98@34.212.201.1:26656,fae8cd5f04406e64484a7a8b6719eacbb861c094@44.241.103.199:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.kyve/config/config.toml

pruning="custom"
pruning_keep_recent="3000"
pruning_interval="100"
snapshot_interval="200"
snapshot_keep_recent="144"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"$snapshot_interval\"/" $HOME/.kyve/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"$snapshot_keep_recent\"/" $HOME/.kyve/config/app.toml


sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:10658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:10657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:10060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:10656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":10660\"%" $HOME/.kyve/config/config.toml

sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:10317\"%; s%^address = \":8080\"%address = \":10080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:10090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:10091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:10545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:10546\"%" $HOME/.kyve/config/app.toml


echo "Билд закончен, переходим к инициализации ноды"
echo "-----------------------------------------------------------------------------"
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/kyved.service
[Unit]
  Description=Kyve Cosmos daemon
  After=network-online.target
[Service]
  User=$USER
  ExecStart=$(which kyved) start
  Restart=on-failure
  RestartSec=10
  LimitNOFILE=65535
[Install]
  WantedBy=multi-user.target
EOF

sudo systemctl enable kyved &>/dev/null
sudo systemctl daemon-reload
sudo systemctl restart kyved

echo "Validator Node $KYVE_NODENAME успешно установлена"
echo "-----------------------------------------------------------------------------"





# source .profile
# kyved keys add $KYVE_NODENAME --recover
# kyved tx staking create-validator   --amount=1000000ukyve   --pubkey=$(kyved tendermint show-validator)   --moniker=Boyar    --chain-id=kyve-1   --commission-rate="0.05"   --commission-max-rate="0.20"   --commission-max-change-rate="0.01"   --min-self-delegation="1000000"    --gas=51000000  --fees=1020000ukyve --yes  --from=Boyar

echo "https://explorer.kyve.network/kyve"
echo "https://docs.kyve.network/validators/chain_nodes/configuration"
echo "https://github.com/KYVENetwork/chain/releases/tag/v1.0.0"
