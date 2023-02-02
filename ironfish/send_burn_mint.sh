#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/ironfish/send_burn_mint.sh)

function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }
  
IRONFISH_NODENAME=`docker exec ironfish ./bin/run config | grep nodeName | awk '{print $2}' | sed 's/\"//g' |  tr ',' ' '`

# mint
docker exec ironfish ./bin/run  wallet:mint -a 1000 -f $IRONFISH_NODENAME -m $IRONFISH_NODENAME -n $IRONFISH_NODENAME -o 0.00000001 --confirm
echo "sleep 500 sec"
sleep_seconds 500

# Burn
ASSET=`docker exec ironfish ./bin/run wallet:balances | grep " $IRONFISH_NODENAME" | awk '{print $2}'`
docker exec ironfish ./bin/run wallet:burn -a 500 -f $IRONFISH_NODENAME -i $ASSET -o 0.00000001 --confirm
echo "sleep 500 sec"
sleep_seconds 500

# Send
docker exec ironfish ./bin/run wallet:send -a 250 -f $IRONFISH_NODENAME -i $ASSET -t dfc2679369551e64e3950e06a88e68466e813c63b100283520045925adbe59ca -o 0.00000001 --confirm

