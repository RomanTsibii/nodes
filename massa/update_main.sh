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
