#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/speed_bootstrap.sh)

# проста функція сліпу щоб не викидало з сервера
function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }
  
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
sleep_seconds 25

while true
    do
      echo "TRY connect to bootstrap and wait"
      LOGS=`journalctl -o cat -u massa -n 3`
      if [[ $LOGS == *"listener addr"* ]]; then break ; fi
      sleep_seconds 15
    done

echo "Bootstrap  sussess and try buy rolls and wait for cheking"

# створюємо кошель і виводимо адрес і зберігаємо
cd $HOME/massa/massa-client
sleep_seconds 15
$(./massa-client --pwd $massa_pass wallet_generate_secret_key)
sleep_seconds 5
echo $(./massa-client --pwd $massa_pass wallet_info | grep "Address" | awk '{print $2}')

# кидаємо адрес в стейк + вписуємо ід з діскорду
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/add_discord_id.sh)

# підключаємо автопокупку ролів
tmux kill-session -t rolls
curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'
