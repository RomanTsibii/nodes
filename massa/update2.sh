#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update2.sh)

# проста функція сліпу щоб не викидало з сервера
function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }
  
# робимо бекап 
cd $HOME
	if [ ! -d $HOME/massa_backup23/ ]; then
		mkdir -p $HOME/massa_backup23
		cp $HOME/massa/massa-node/config/node_privkey.key $HOME/massa_backup23/
		cp $HOME/massa/massa-client/wallet.dat $HOME/massa_backup23/
	fi
	if [ ! -e $HOME/massa_backup23.tar.gz ]; then
		tar cvzf massa_backup.tar21.gz massa_backup23
	fi
  
# чистка профайлу
sed -i '/alias client/d' $HOME/.profile
source $HOME/.profile
echo "alias client='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile
echo "alias clientw='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile

# актуальне оновлення
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/massa/update.sh)

# міняємо час для швидкого конекту до пірів
config_path="$HOME/massa/massa-node/base_config/config.toml"
sed -i -e "s%retry_delay *=.*%retry_delay = 15000%; " "$config_path"
sudo systemctl restart massa

# створюємо кошель і виводимо адрес і зберігаємо
#cd $HOME/massa/massa-client
#$(./massa-client --pwd $massa_pass wallet_generate_secret_key)
#sleep_seconds 5
#echo $(./massa-client --pwd $massa_pass wallet_info | grep "Address" | awk '{print $2}')

# піднімаємо бекап
cp $HOME/massa_backup23/wallet.dat $HOME/massa/massa-client/wallet.dat
cp $HOME/massa_backup23/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key
sudo systemctl restart massa
sleep_seconds 35
# почекати на норм логи
while true
    do
      LOGS=`journalctl -o cat -u massa -n 3`
      if ! [[ $LOGS == *"Successful bootstrap"* ]]; then break ; fi
      sleep_seconds 15
    done

echo $LOGS
# кидаємо адрес в стейк + вписуємо ід з діскорду
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/add_discord_id.sh)

# підключаємо автопокупку ролів
tmux kill-session -t rolls
curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'
