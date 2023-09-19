#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/reboot_wait_buy.sh)
# проста функція сліпу щоб не викидало з сервера
function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }
sudo systemctl restart massa
while true
    do
      echo "TRY connect to bootstrap and wait"
      LOGS=`journalctl -o cat -u massa -n 5`
      if [[ $LOGS == *"listener addr"* ]]; then break ; fi
      sleep_seconds 5
    done

echo "Bootstrap  sussess and try buy rolls and wait for cheking"
# кидаємо адрес в стейк + вписуємо ід з діскорду
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/add_discord_id.sh)

# підключаємо автопокупку ролів

tmux kill-session -t rolls
curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

sleep_seconds 80
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/show_rolls.sh)
