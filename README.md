### nodes

# subspace 

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

# massa

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)

# tmux

tmux attach -t rolls


cd $HOME

pkill -9 tmux 

curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

# minima
авто запит кожного дня в 10am

в скрипті потрібно вписати свій ід з сайту

history | grep "curl 127.0.0.1"

cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab.sh > minima_crontab.sh && chmod +x minima_crontab.sh && ./minima_crontab.sh && ./minima_autorun_every_day.sh



tmux new-session -d -s minima './run_every_day_at_17.sh'
# KYVE

update Kysama-substrate

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/kyve/update_kysama.sh)

update cosmos(umee, injective)

cd $HOME/kyve 
wget https://github.com/kyve-org/cosmos/releases/download/v0.3.5/kyve-linux.zip
unzip kyve-linux.zip 
source $HOME/.profile
rm -rf __MACOSX/ kyve-linux.zip 
chmod u+x kyve-linux 
mv kyve-linux /usr/bin/kyve-??


sudo systemctl daemon-reload && \
sudo systemctl enable kyved && \
sudo systemctl enable kyve-injective && \
sudo systemctl restart kyved && \
sudo systemctl restart kyve-injective

cd $HOME/kyve
wget https://github.com/kyve-org/substrate/releases/download/v0.1.2/kyve-linux.zip
unzip kyve-linux.zip 
source $HOME/.profile
rm -rf __MACOSX/ kyve-linux.zip 
chmod u+x kyve-linux 
mv kyve-linux /usr/bin/kyve-Kusama

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
або 
sudo journalctl -u kyve-injective -f -o cat

  /etc/systemd/system/kyve-injective.service
  
# PENUMBRA
  
  get wallet address
  
  `bash <( curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/wallet.sh)` 
  
docker

Stop all running containers: docker stop $(docker ps -a -q)

Delete all stopped containers: docker rm $(docker ps -a -q)

# ssh connect without pass

ssh-keygen # генеримо ключі(декілька разів просто ентр)

ssh-copy-id root@[IP] # копіюємо ключі на сервер на який у майбутньому будемо конектитись без паролю(треба ввести пароль) (треба на всі ІР підкидати свій ключ)
           
sshpass -p 'YOUR_PASS' ssh-copy-id root@YOUR_IP
           
# remove all docker with tag "<none" - for ironfish

docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'

docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
           
# upgrade contabo memory ssh || nvme
           
![image](https://user-images.githubusercontent.com/43521642/192228958-dd17e4c5-8db5-4547-b180-683685be5aee.png)
           
rm -rf /var/log/*

apt install cloud-guest-utils

growpart /dev/sda 3
           
resize2fs /dev/sda3


# Get FREE SPACE  
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/freeing_memory.sh)

