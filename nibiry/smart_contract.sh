apt update
curl -s https://get.nibiru.fi/! | bash
nibid version

nibid config node https://rpc.itn-1.nibiru.fi:443
nibid config chain-id nibiru-itn-1
nibid config broadcast-mode block
nibid config keyring-backend test
nibid keys add wallet --recover

mkdir contract && cd contract
wget https://github.com/NibiruChain/cw-nibiru/raw/main/artifacts-cw-plus/cw20_base.wasm
CONTRACT_WASM="$HOME/contract/cw20_base.wasm"
nibid tx wasm store $CONTRACT_WASM --from wallet --gas=3000000 --fees=80000unibi -y

# зберегти code_id 
code_id=
ADDRESS=


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

CONTRACT=nibi1zhyznzp6ssn804nzj6a4gzmmam40vgwd5vnyyhtglaw8wwec8yjqeyxvcv

TRANSFER='{"transfer":{"recipient":"nibi1g6zkqul6g8tfkztdrpdq4f0alcy2js77gfn9v6","amount":"50"}}'

nibid tx wasm execute $CONTRACT $TRANSFER --gas=3000000 --fees=80000unibi --from wallet -y

