#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_helscheck.sh) 
# screen -S avail_helscheck -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_helscheck.sh)"

while true
  do
    # fail=$(tail -n 10 screenlog.0 | grep "Avail has been added to your profile.")
    # fail1=(tail -n 10 screenlog.0 | grep "Avail stopped")
    # if [ -n "$fail"  ] || [ -n $fail1 ]
    # then

    sleep 1
    echo "restart avail" 
    screen -dmS avail -L
    sleep 1
    screen -S avail -X colon "logfile flush 0^M"  
    sleep 1
    screen -S avail -X stuff "curl -sL1 avail.sh | bash"
    sleep 1
    screen -S avail -X stuff $'\n' # press enter
    # fi
    sleep 20m
    screen -XS avail quit
  done
  
