## ruby

all.gsub("\n", ' root@').gsub("root@ ", '').prepend("clusterssh root@")

all.gsub("  session closed\n", ' root@').gsub("root@ ", '').prepend("clusterssh root@").gsub("  session closed", "")

emails.split("\n").each { |email|  puts email.split(':')[2] }
 
operator=["50", "66", "63", "95", "97", "99", "98"]
 
(1...120).each { puts "#{operator.sample} #{rand(100...999)} #{rand(1000...9999)}" }

### nodes

# rm logs

rm -rf /var/log/syslog.2
rm -rf /var/log/syslog.1
rm -rf /var/log/syslog


# subspace 

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

# massa

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)

# tmux

tmux attach -t rolls

tmux kill-session -t rolls

cd $HOME

pkill -9 tmux 

curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

# Minima

### Перший запуск на сервері для створення всіх портібних файлів

cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab9001-9032.sh > crontab9001-9032.sh && chmod +x crontab9001-9032.sh && ./crontab9001-9032.sh

автопропінговка в 01, 03, 05, 07 (кожного дня) 

в скрипті потрібно вписати свій ід з сайту разом з curl

Приклад

curl 127.0.0.1:9005/incentivecash%20uid:86d1c407-6e15-4962-88af-586719debee3

### добавляємо всі UID з акаунта мініми в файл minima_autorun_every_day.sh

nano minima_autorun_every_day.sh

### коли помилки або потрібно 1 раз самому запустити пропінговку

зайти на сервер і запустити (воно запустить переустановку на всіх портах на яких стоїть мініма)

перевірити чи є на сервері місце

./minima_reping_base.sh

### для запуску бота з телеграму треба зайти на сервер (ІР сервера в таблиці мініми на В1(голубим позначений))
### і запустити код нижче (він запуститься (буде процес мініма))

tmux new-session -d -s minima './run_every_day_at_17.sh'

## можна перевірити чи працює бот запустивши 

tmux ls

### після запуску бота можна з сервера виходити і чекати сповіщення в телегамі

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

# Disable access by password | ONE COMMAND

sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \

sudo systemctl restart ssh.service
           
# remove all docker with tag "<none" - for ironfish

docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'

docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
           
# upgrade contabo memory ssh || nvme
           
![image](https://user-images.githubusercontent.com/43521642/192228958-dd17e4c5-8db5-4547-b180-683685be5aee.png)
           
rm -rf /var/log/*
           
df -h

apt install cloud-guest-utils

growpart /dev/sda 3
           
resize2fs /dev/sda3


# Get FREE SPACE  
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/freeing_memory.sh)

# Zeeka Network

### Update

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/zeeka/update.sh)

# Setup new server

bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/setup_new_server.sh)

# Якщо довго грузить source $HOME/.profile
 
## для запуску просто копіюємо і вставляємо команди нижче
 
`bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/remove_copy_clientw.sh)`

`source $HOME/.profile`
 
# Set varieble to bash script

![image](https://user-images.githubusercontent.com/43521642/198118223-96e2e9d1-ba22-4f8a-8f96-8fbdc9fbc1c8.png)

