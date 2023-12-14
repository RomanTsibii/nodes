#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/crontab.sh)

function sleep_min () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1m
    done
    echo " "
  }

for i in {1..50}
do
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 6'
  sleep_min 60 
  tmux kill-session -t squid_restart
  
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 6'
  sleep_min 60
  tmux kill-session -t squid_restart
  
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 7'
  sleep_min 360
  tmux kill-session -t squid_restart
  
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 7'
  sleep_min 360
  tmux kill-session -t squid_restart
  
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 7'
  sleep_min 120
  tmux kill-session -t squid_restart
done
