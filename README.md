### nodes
# subspace 
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

# massa
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)

cd $HOME

pkill -9 tmux 

curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

# minima
авто запит кожного дня в 10am

в скрипті потрібно вписати свій ід з сайту

history | grep "curl 127.0.0.1"

cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab.sh > minima_crontab.sh && chmod +x minima_crontab.sh && ./minima_crontab.sh && ./minima_autorun_every_day.sh


# KYVE

cd kyve 
wget https://github.com/kyve-org/substrate/releases/download/v0.0.3/kyve-linux.zip
unzip kyve-linux.zip 
source $HOME/.profile
rm -rf __MACOSX/ kyve-linux.zip 
chmod u+x kyve-linux 
mv kyve-linux kyve-substrate
cp kyve-substrate /usr/bin/kyve-Kusama
POOL=18
BIN="kyve-Kusama"
MNEMONIC=""
STAKE=5000

### згенерити arweve.json і закинути в root

sudo tee <<EOF >/dev/null /etc/systemd/system/kyve-kysama.service
[Unit]
Description=Kyve Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $BIN) \\
--poolId $POOL \\
--mnemonic "$MNEMONIC" \\
--initialStake $STAKE \\
--keyfile /root/arweave.json \\
--network korellia \\
--verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
  
# запускаем ноду
sudo systemctl daemon-reload && \
sudo systemctl enable kyve-kysama && \
sudo systemctl restart kyve-kysama
  
# проверяем логи
sudo journalctl -u kyve-kysama -f -o cat
або 
sudo journalctl -u kyved -f -o cat

  
### penumbra 
  get wallet address
  bash <( curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/wallet.sh)
