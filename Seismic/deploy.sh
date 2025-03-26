#!/bin/bash
# source ~/.bashrc; bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Seismic/deploy.sh) PRIV_KEY ADDRESS

source ~/.bashrc

WALLET_FILE="/root/try-devnet/packages/common/wallet.sh"

# Зчитуємо значення PRIV та ADDRESS
if [ -n "$1" ]; then
  PRIV="$1"
else
  read -p "Enter your PRIV_KEY 0x:" PRIV
fi

if [ -n "$2" ]; then
  ADDRESS="$2"
else
  read -p "Enter your WALLET_ADDRESS 0x:" ADDRESS
fi

# Заміна рядків з 4 пробілами + DEV_WALLET_ADDRESS=
sed -i "s|^    DEV_WALLET_ADDRESS=.*|    DEV_WALLET_ADDRESS=\"$ADDRESS\"|" "$WALLET_FILE"

# Заміна рядків з 4 пробілами + DEV_WALLET_PRIVKEY=
sed -i "s|^    DEV_WALLET_PRIVKEY=.*|    DEV_WALLET_PRIVKEY=\"$PRIV\"|" "$WALLET_FILE"

# Замінюємо echo з -ne на -e
sed -i 's/echo\s\+-ne/echo -e/g' "$WALLET_FILE"
sed -i 's/echo\s\+-ne/echo -e/g' /root/try-devnet/packages/cli/script/transact.sh
sed -i 's/echo\s\+-ne/echo -e/g' /root/try-devnet/packages/contract/script/deploy.sh

# Коментуємо рядки з read -r
sed -i 's/^\(.*read\s\+-r.*\)/# \1/' "$WALLET_FILE"
sed -i 's/^\(.*read\s\+-r.*\)/# \1/' /root/try-devnet/packages/cli/script/transact.sh
sed -i 's/^\(.*read\s\+-r.*\)/# \1/' /root/try-devnet/packages/contract/script/deploy.sh

echo "------------------------------------------contract deploy------------------------------------------"
cd $HOME/try-devnet/packages/contract/
bash script/deploy.sh
echo "-------------------------------------------cli transact--------------------------------------------"
cd $HOME/try-devnet/packages/cli/
bash script/transact.sh
