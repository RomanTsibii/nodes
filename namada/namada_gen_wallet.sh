#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/namada/namada_install.sh)

source $HOME/.profile
source $HOME/.bash_profile

cd $HOME
namada wallet address gen --alias wallet_name
#enter pass
namada client init-validator --alias $VALIDATOR_ALIAS --source wallet_name --commission-rate 0.05 --max-commission-rate-change 0.01
#enter pass

cd $HOME
namadac transfer \
    --token NAM \
    --amount 1000 \
    --source faucet \
    --target $VALIDATOR_ALIAS \
    --signer $VALIDATOR_ALIAS
	
#use faucet again because min stake 1000 and you need some more NAM
namadac transfer \
    --token NAM \
    --amount 1000 \
    --source faucet \
    --target $VALIDATOR_ALIAS \
    --signer $VALIDATOR_ALIAS
	
#check balance
namada client balance --owner $VALIDATOR_ALIAS --token NAM

#stake your funds
namada client bond \
  --validator $VALIDATOR_ALIAS \
  --amount 1500
  
