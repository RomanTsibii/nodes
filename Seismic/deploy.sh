#!/bin/bash
# source ~/.bashrc; bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Seismic/deploy.sh) PRIV_KEY

source ~/.bashrc
cd $HOME/try-devnet/packages/contract/

if [ -n "$1" ]; then
  PRIV="$1"
else
  read -p "Enter your PRIV_KEY without 0x:" PRIV
fi

FILE="/root/try-devnet/packages/contract/script/deploy.sh"

# Видаляємо рядок, що містить 'dev_wallet'
sed -i '/dev_wallet/d' "$FILE"
sed -i '/prelude/d' "$FILE"
sed -i '/^prelude() {/,/^}/d' "$FILE"

# Замінюємо рядок з privkey=... на privkey=$PRIV
sed -i "s/^privkey=.*/privkey=$PRIV/" "$FILE"

bash script/deploy.sh
