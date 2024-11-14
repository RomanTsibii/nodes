#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/Unichain/install.sh)

curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/rust.sh | bash
source $HOME/.profile
source "$HOME/.cargo/env"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/foundry.sh | bash

source ~/.bashrc
foundryup
rustc -V
cast -V

cd $HOME
rm -rf aligned_layer
git clone https://github.com/yetanotherco/aligned_layer.git && cd aligned_layer


