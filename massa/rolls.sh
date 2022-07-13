#!/bin/bash

# pkill -9 tmux 
# curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

rm -f $HOME/massa/massa-client/massa-client
if [ ! -e $HOME/massa/massa-client/massa-client ]; then
  wget https://raw.githubusercontent.com/razumv/helpers/main/massa/massa-client -O $HOME/massa/massa-client/massa-client
  chmod +x $HOME/massa/massa-client/massa-client
fi


source .profile
cd $HOME/massa/massa-client
massa_wallet_address=$(./massa-client -p $massa_pass wallet_info | grep Address | awk '{ print $2 }')

while true
do
        balance=$(./massa-client -p $massa_pass wallet_info | grep "Final balance" | awk '{ print $3 }')
        int_balance=${balance%%.*}
        if [[ $int_balance -gt "99" ]]; then
                echo "More than 99"
                resp=$(./massa-client  -p $massa_pass buy_rolls $massa_wallet_address $(($int_balance/100)) 0)
                echo $resp
        elif [[ $int_balance -lt "100" ]]; then
                echo "Less than 100"
        fi

#         massa_logs=`journalctl -n 1 -u massa`
#         if [[ $massa_logs == *"Send network event failed An error occurred during channel communication: Failed to send event"* ]]; then 
#                 echo 'Restarting...'
#                 systemctl restart massa
#         fi
#         if [[ $massa_logs == *"speculative execution cache empty, executing final slot"* ]]; then 
#                 echo 'Restarting...'
#                 systemctl restart massa
#         fi
        
#         massa_logs=`journalctl -n 30 -u massa`
#         if [[ $massa_logs == *"RUST_BACKTRACE=1"* ]]; then 
#                 echo 'Updating massa'
#                 RUST_BACKTRACE=1
#                 bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)
#         fi
        
        staking_registered_address=$(./massa-client  -p $massa_pass node_get_staking_addresses)
        staking_address=$(./massa-client  -p $massa_pass wallet_info | grep 'Address' | cut -d\   -f2)
        
        if [ "$staking_registered_address" = "$staking_address" ]; then
               echo "Node was registered"
        else
               echo "Node wasn't registered"
               ./massa-client -p $massa_pass node_add_staking_secret_keys $(./massa-client  -p $massa_pass wallet_info | grep 'Secret key' | cut -d\    -f3)
        fi
        
        printf "sleep"
        for((sec=0; sec<60; sec++))
        do
                printf "."
                sleep 1
        done
        printf "\n"
done
