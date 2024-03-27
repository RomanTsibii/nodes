#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)

array[0]="5penumbra"
array[1]="10penumbra"
array[2]="15penumbra"
array[3]="20penumbra"
array[4]="25penumbra"
array[5]="30penumbra"
array[6]="35penumbra"
array[7]="40penumbra"

random_loop=$((1 + RANDOM % 3))
size1=${#array[@]}
for i in $(seq $random_loop); do  
  index=$(($RANDOM % $size1))
  echo ${array[$index]}

  # pcli tx delegate ${array[$index]} --to ${validaaddress[$index]}
 pcli tx delegate ${array[$index]} --to $(pcli query validator list | grep penumbravalid | awk '{print $6}' | shuf -n 1)
done
sleep 5
pcli view staked
