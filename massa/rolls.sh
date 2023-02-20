#!/bin/bash

# pkill -9 tmux 
# curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'



cd $HOME/massa/massa-client
massa_wallet_address=$(./massa-client --pwd $massa_pass wallet_info | grep Address | awk '{ print $2 }')
./massa-client -p $massa_pass node_start_staking  $massa_wallet_address


while true
do
        balance=$(./massa-client --pwd $massa_pass wallet_info | grep "Rolls" | awk '{ print $3 }' | sed 's/final=//;s/,//')
        int_balance=${balance%%.*}
        if [ $int_balance -lt "1" ]; then
                echo "Less than 1 Final Roll"
                resp=$(./massa-client --pwd $massa_pass buy_rolls $massa_wallet_address 1 0)
                echo $resp
        elif [ $int_balance -gt "1" ]; then
                echo "More than 1 Final Roll"
        fi
        date=$(date +"%H:%M")
        echo Last Update: ${date}
        printf "sleep"
        for((m=0; m<60; m++))
        do
                printf "."
                sleep 1m
        done
        printf "\n"
done










:'
source $HOME/.profile
cd $HOME/massa/massa-client
massa_wallet_address=$(./massa-client --pwd $massa_pass wallet_info | grep Address | awk '{ print $2 }')

./massa-client -p $massa_pass node_start_staking  $massa_wallet_address

while true
do
        balance=$(./massa-client --pwd $massa_pass wallet_info | grep "Balance" | awk '{ print $3 }' | sed 's/candidate=//;s/,//')
        candidate_rolls=$(./massa-client --pwd $massa_pass wallet_info | grep "Rolls" | awk '{ print $4 }' | sed 's/candidate=//;s/,//')
        int_balance=${balance%%.*}
        int_candidate_rolls=${candidate_rolls%%.*}
        if [ $int_balance -gt "99" ] && [ $int_candidate_rolls = "0" ]; then   
                echo "More than 99"
                resp=$(./massa-client --pwd $massa_pass buy_rolls $massa_wallet_address 1 0)
                echo $resp
        else
                echo "Less than 100"
        fi
        printf "sleep"
        for((sec=0; sec<60; sec++))
        do
                printf "."
                sleep 1
        done
        printf "\n"
done
'
#          massa_logs=`journalctl -n 1 -u massa`
#          if [[ $massa_logs == *"Send network event failed An error occurred during channel communication: Failed to send event"* ]]; then 
#                  echo 'Restarting...'
#                  systemctl restart massa
#          fi
#         if [[ $massa_logs == *"speculative execution cache empty, executing final slot"* ]]; then 
#                 echo 'Restarting...'
#                 systemctl restart massa
#         fi
#         
#         massa_logs=`journalctl -n 30 -u massa`
#         if [[ $massa_logs == *"RUST_BACKTRACE=1"* ]]; then 
#                 echo 'Updating massa'
#                 RUST_BACKTRACE=1
#                 bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)
#         fi
#         
#         staking_registered_address=$(./massa-client  -p $massa_pass node_get_staking_addresses)
#         staking_address=$(./massa-client  -p $massa_pass wallet_info | grep 'Address' | cut -d\   -f2)
#         
#         if [ "$staking_registered_address" = "$staking_address" ]; then
#                echo "Node was registered"
#         else
#                echo "Node wasn't registered"
#                ./massa-client -p $massa_pass node_add_staking_secret_keys $(./massa-client  -p $massa_pass wallet_info | grep 'Secret key' | cut -d\    -f3)
#         fi
