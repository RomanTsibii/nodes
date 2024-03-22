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

validaaddress[0]=$(pcli query validator list | grep penumbravalid | awk '{print $6}' | shuf -n 1) # одна рандомка адреса валідатора серед всіх
validaaddress[1]=$(pcli query validator list | grep penumbravalid | awk '{print $6}' | shuf -n 1) # одна рандомка адреса валідатора серед всіх
validaaddress[2]=$(pcli query validator list | grep penumbravalid | awk '{print $6}' | shuf -n 1) # одна рандомка адреса валідатора серед всіх

random_loop=$((1 + RANDOM % 3))
for i in $(seq $random_loop); do 
  size=${#validaaddress[@]}
  index=$(($RANDOM % $size))
  echo ${validaaddress[$index]}
  
  size1=${#array[@]}
  index=$(($RANDOM % $size1))
  echo ${array[$index]}

  pcli tx delegate ${array[$index]} --to ${validaaddress[$index]}
done
sleep 5
pcli view staked
