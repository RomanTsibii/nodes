#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/aleo/smart-contract-with-variabl.sh) PK VK ADDRESS NAME QUOTE_LINK

PK=$1 # PRIVATE_KEY
VK=$2 # View Key
ADDRESS=$3 # Address
NAME=$4 # 
QUOTE_LINK=$5 # 



CIPHERTEXT=$(curl -s $QUOTE_LINK | jq -r '.execution.transitions[0].outputs[0].value')
cd $HOME && cd leo_deploy && leo new $NAME

RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)

snarkos developer deploy "$NAME.aleo" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--path "$HOME/leo_deploy/$NAME/build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 5000000 \
--record "$RECORD"
