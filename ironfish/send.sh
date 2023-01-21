#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/send.sh)

WALLETS="
0ca441db8f93acd0fc83d97e9a59a1bfcf1feb1dd61c76175f27d2939975eeea
dda484d1f131ef03fda4b90bc134f578fe34b0065845c8dad7861475004581b7
  "

for WALLET in ${WALLETS} ; do
  docker exec ironfish ./bin/run wallet:send -a 0.018 -i d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6 -t $WALLET -o 0.001 --confirm
    sleep 300
done


