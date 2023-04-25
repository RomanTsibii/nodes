#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/nibiry/smart_contract.sh)

rm -rf contract
apt update
curl -s https://get.nibiru.fi/! | bash
nibid version

nibid config node https://rpc.itn-1.nibiru.fi:443
nibid config chain-id nibiru-itn-1
nibid config broadcast-mode block
nibid config keyring-backend test
read -p "ADDRESS: " ADDRESS
nibid keys add wallet --recover

mkdir contract 
cd contract
wget https://github.com/NibiruChain/cw-nibiru/raw/main/artifacts-cw-plus/cw20_base.wasm
CONTRACT_WASM="$HOME/contract/cw20_base.wasm"
nibid tx wasm store $CONTRACT_WASM --from wallet --gas=3000000 --fees=80000unibi -y

# зберегти code_id 
read -p "code_id: " code_id
#code_id=
#ADDRESS=


sudo tee -a $HOME/contract/inst.json  >/dev/null <<EOF
{
  "name": "Custom CW20 token",
  "symbol": "CWXX",
  "decimals": 6,
  "initial_balances": [
    {
      "address": "$ADDRESS",
      "amount": "555444000"
    }
  ],
  "mint": { "minter": "$ADDRESS" },
  "marketing": {}
}
EOF



nibid tx wasm inst $code_id "$(cat inst.json)" --label="mint CWXX contract" --no-admin --from=wallet --gas=2000000 --fees=50000unibi -y

# зберегти contract_address
read -p "CONTRACT: " CONTRACT
#CONTRACT=nibi1zhyznzp6ssn804nzj6a4gzmmam40vgwd5vnyyhtglaw8wwec8yjqeyxvcv

TRANSFER1='{"transfer":{"recipient":"nibi12lcsfjdymnta7yejww25em4f2j4cawh0nu42dd","amount":"50"}}'
TRANSFER2='{"transfer":{"recipient":"nibi130axd6lmeyym5r6galsepqx8lnkgugpgkytjp0","amount":"50"}}'
TRANSFER3='{"transfer":{"recipient":"nibi190fxan9uhtsg39vcjq8m3fdjka8eujdnq4zqlr","amount":"50"}}'
TRANSFER4='{"transfer":{"recipient":"nibi1uzreuedcfq6tg7l48azvzxu8xnxfh3f2kmgk7g","amount":"50"}}'
TRANSFER5='{"transfer":{"recipient":"nibi1g3scwmqrr4hnjpe6l68n5fh5x5vmltc0qasfql","amount":"50"}}'
ARRAY=($TRANSFER1 $TRANSFER2 $TRANSFER3 $TRANSFER4 $TRANSFER5)
TRANSFER=${ARRAY[RANDOM % 5]}

nibid tx wasm execute $CONTRACT $TRANSFER --gas=3000000 --fees=80000unibi --from wallet -y

