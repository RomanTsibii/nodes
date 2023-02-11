#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/send.sh)

WALLETS="
7b036c6f22b9d0397c27c448cdeb07a33a5f9273a07305dac808d12f23ec0e06
b42fc78b6fb8eeeb629d138df332c72b4fa15d5885d0dc1c0afac33b9becc2a5
d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6
  "

for WALLET in ${WALLETS} ; do
  docker exec ironfish ./bin/run wallet:send -a 0.018 -i d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6 -t $WALLET -o 0.001 --confirm
    sleep 300
done


