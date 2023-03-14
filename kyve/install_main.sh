
kyved tx staking create-validator   --amount=1000000ukyve   --pubkey=$(kyved tendermint show-validator)   --moniker=Boyar    --chain-id=kyve-1   --commission-rate="0.05"   --commission-max-rate="0.20"   --commission-max-change-rate="0.01"   --min-self-delegation="1000000"    --gas=51000000  --fees=1020000ukyve --yes  -
-from=Boyar
