#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_12.sh)

source $HOME/.profile
source $HOME/.cargo/env

#add ufw rules
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_ufw.sh | bash

sudo systemctl stop massa
rustup toolchain install nightly
rustup default nightly

cd $HOME
if [ ! -d $HOME/massa_backup/ ]; then
	mkdir -p $HOME/massa_backup
	cp $HOME/massa/massa-node/config/node_privkey.key $HOME/massa_backup/
	cp $HOME/massa/massa-client/wallet.dat $HOME/massa_backup/
fi
if [ ! -e $HOME/massa_backup.tar.gz ]; then
	tar cvzf massa_backup.tar.gz massa_backup
fi

rm -rf $HOME/massa
git clone https://github.com/massalabs/massa.git
cd $HOME/massa
git checkout -- massa-node/config/config.toml
git checkout -- massa-node/config/peers.json
git fetch
sleep 2
git checkout TEST.11.3

cd $HOME/massa/massa-node/
cargo build --release
#sed -i 's%bootstrap_list *=.*%bootstrap_list = [ [ "62.171.166.224:31245", "8Cf1sQA9VYyUMcDpDRi2TBHQCuMEB7HgMHHdFcsa13m4g6Ee2h",], [ "149.202.86.103:31245", "5GcSNukkKePWpNSjx9STyoEZniJAN4U4EUzdsQyqhuP3WYf6nj",], [ "149.202.89.125:31245", "5wDwi2GYPniGLzpDfKjXJrmHV3p1rLRmm4bQ9TUWNVkpYmd4Zm",], [ "158.69.120.215:31245", "5QbsTjSoKzYc8uBbwPCap392CoMQfZ2jviyq492LZPpijctb9c",], [ "158.69.23.120:31245", "8139kbee951YJdwK99odM7e6V3eW7XShCfX5E2ovG3b9qxqqrq",],]%' "$HOME/massa/massa-node/base_config/config.toml"
sed -i "s/ip *=.*/ip = \"127\.0\.0\.1\"/" "$HOME/massa/massa-client/base_config/config.toml"
sed -i "s/^bind_private *=.*/bind_private = \"127\.0\.0\.1\:33034\"/" "$HOME/massa/massa-node/base_config/config.toml"
sed -i "s/^bind_public *=.*/bind_public = \"0\.0\.0\.0\:33035\"/" "$HOME/massa/massa-node/base_config/config.toml"
sed -i 's/.*routable_ip/# \0/' "$HOME/massa/massa-node/base_config/config.toml"
sed -i "/\[network\]/a routable_ip=\"$(curl -s ifconfig.me)\"" "$HOME/massa/massa-node/base_config/config.toml"

cp $HOME/massa_backup/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key

cd $HOME/massa/massa-client/
cargo build --release
cp $HOME/massa_backup/wallet.dat $HOME/massa/massa-client/wallet.dat
sudo systemctl restart massa
sleep 10
curl -s https://raw.githubusercontent.com/razumv/helpers/main/massa/bootstrap-fix.sh | bash

echo "run autobuy"
sleep 15
cd $HOME
pkill -9 tmux 
curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'
echo DONE







---------------------------------------------------
#/bin/bash

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/razumv/helpers/main/doubletop.sh | bash
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function create_backup {
  cd $HOME
  if [ ! -d $HOME/massa_backup_12/ ]; then
	mkdir -p $HOME/massa_backup_12
	cp $HOME/massa/massa-node/config/node_privkey.key $HOME/massa_backup/
	cp $HOME/massa/massa-client/wallet.dat $HOME/massa_backup/
  fi
  if [ ! -e $HOME/massa_backup_12.tar.gz ]; then
	tar cvzf massa_backup_12.tar.gz massa_backup_12
  fi
}

function delete {
  sudo systemctl stop massa
  rm -rf $HOME/massa
}

function install {
  wget https://github.com/massalabs/massa/releases/download/TEST.12.0/massa_TEST.12.0_release_linux.tar.gz
  tar zxvf massa_TEST.12.0_release_linux.tar.gz -C $HOME/
  echo "restore wallet from backup"
  cp $HOME/massa_backup_12/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key
  cp $HOME/massa_backup_12/wallet.dat $HOME/massa/massa-client/wallet.dat
}

function routable_ip {
  sed -i 's/.*routable_ip/# \0/' "$HOME/massa/massa-node/base_config/config.toml"
  sed -i "/\[network\]/a routable_ip=\"$(curl -s ifconfig.me)\"" "$HOME/massa/massa-node/base_config/config.toml"
}

function replace_bootstraps {
  	config_path="$HOME/massa/massa-node/base_config/config.toml"
  	bootstrap_list=`wget -qO- https://raw.githubusercontent.com/SecorD0/Massa/main/bootstrap_list.txt | shuf -n50 | awk '{ print "        "$0"," }'`
  	len=`wc -l < "$config_path"`
  	start=`grep -n bootstrap_list "$config_path" | cut -d: -f1`
  	end=`grep -n "\[optionnal\] port on which to listen" "$config_path" | cut -d: -f1`
  	end=$((end-1))
  	first_part=`sed "${start},${len}d" "$config_path"`
  	second_part="
      bootstrap_list = [
  ${bootstrap_list}
      ]
  "
  	third_part=`sed "1,${end}d" "$config_path"`
  	echo "${first_part}${second_part}${third_part}" > "$config_path"
  	sed -i -e "s%retry_delay *=.*%retry_delay = 10000%; " "$config_path"
}

function massa_pass {
  if [ ! ${massa_pass} ]; then
  echo "Введите свой пароль для клиента(придумайте)"
  line
  read massa_pass
  fi
  echo "export massa_pass=$massa_pass" >> $HOME/.profile
  source $HOME/.profile
}

function systemd {
  sudo tee <<EOF >/dev/null /etc/systemd/system/massa.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node -p "$massa_pass"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable massa
sudo systemctl restart massa
}

function alias {
  echo "alias client='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile
  echo "alias clientw='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile
}


function auto_buy {
  echo "run autobuy"
  sleep 15
  cd $HOME
  pkill -9 tmux 
  curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'
  echo DONE
}

colors
line
logo
line
massa_pass
create_backup
delete
install
routable_ip
line
replace_bootstraps
line
systemd
line
alias
auto_buy
echo "Готово, ваш пароль от клиента - $massa_pass"
