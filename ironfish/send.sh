#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/send.sh)

function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }
  
WALLETS="
485b12f3dd3c14611c17820175aa75121ec2776905d6f8e2af27c7e2924980ae
ff7f4bcacdfaa97656cd350b012bfb6ed860dc3e6660577b13bf43affd3a5342
  "

for WALLET in ${WALLETS} ; do
  docker exec ironfish ./bin/run wallet:send -a 0.018 -i d7c86706f5817aa718cd1cfad03233bcd64a7789fd9422d3b17af6823a7e6ac6 -t $WALLET -o 0.001 --confirm
    sleep_seconds 300
done


