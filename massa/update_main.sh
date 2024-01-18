#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_main.sh)

# робимо бекап 
cd $HOME
if [ ! -d $HOME/massa_backup_main/ ]; then
  mkdir -p $HOME/massa_backup_main
  cp $HOME/massa/massa-node/config/node_privkey.key $HOME/massa_backup_main/
  cp -r $HOME/massa/massa-client/wallets/ $HOME/massa_backup_main/wallets/
fi

# актуальне оновлення
sudo systemctl stop massad
cd $HOME
rm -rf $HOME/massa
wget https://github.com/massalabs/massa/releases/download/MAIN.2.1/massa_MAIN.2.1_release_linux.tar.gz
tar zxvf massa_MAIN.2.1_release_linux.tar.gz
rm massa_MAIN.2.1_release_linux.tar.gz

# піднімаємо бекап
cp -r $HOME/massa_backup_main/wallets/ $HOME/massa/massa-client/
cp $HOME/massa_backup_main/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key

sudo systemctl start massad

# глянути логи 
# sudo journalctl -u massad -f
echo "sudo journalctl -u massad -f"

# перезапустити і глянути логи 
# sudo systemctl restart massad && sudo journalctl -u massad -f

# відкрити  клієнт
# cd massa/massa-client && ./massa-client

# зупинити автопокупку(якщо запускали) 
# tmux kill-session -t massa_buy_rolls_mainnet 

# для сповіщень в тг при покупці ролів (значення підставляємо свої) 
# echo BOT_TOKEN=6254818806:AAHi1TJs0GC2Q2eOAmSvhiQm2DzF0jw2UNQ >> $HOME/.profile 
# echo CHAT_ID=351645047 >> $HOME/.profile
# запустити автопокупку (міняємо massa_password - на свій пароль в массі)
# tmux new-session -d -s massa_buy_rolls_mainnet 'bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/autobuy_rolls_mainet.sh) massa_password'


