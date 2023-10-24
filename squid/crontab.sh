#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/remove_db_crontab.sh)

function sleep_min () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1m
    done
    echo " "
  }

for i in {1..100}
do
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 5'
  sleep_min 30 
  tmux kill-session -t squid_restart
done
