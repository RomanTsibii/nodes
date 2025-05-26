#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/drosera/helper.sh) 

# rm -rf /root/.drosera
rm -f /tmp/drosera_install.log /tmp/drosera*.tar.gz /tmp/drosera_install.sh
rm -rf ~/drosera
VERSION="v1.16.2"
ARCH="x86_64"
PLATFORM="unknown-linux-gnu"
curl -L -o /tmp/drosera.tar.gz "https://github.com/drosera-network/releases/releases/download/$VERSION/drosera-$VERSION-$ARCH-$PLATFORM.tar.gz"
mkdir -p ~/.drosera/bin
tar -xvzf /tmp/drosera.tar.gz -C ~/.drosera/bin
export PATH="$HOME/.drosera/bin:$PATH"
source ~/.bashrc
which drosera
cd ~
curl -LO https://github.com/drosera-network/releases/releases/download/v1.17.2/drosera-operator-v1.17.2-x86_64-unknown-linux-gnu.tar.gz
tar -xvf drosera-operator-v1.17.2-x86_64-unknown-linux-gnu.tar.gz
./drosera-operator --version
sudo mv drosera-operator /usr/local/bin/
