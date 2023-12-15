#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/crontab.sh) 2 13 0
echo $1
echo $2
echo $3
RUN_CRYPTOPUNKS_TIMES=$1
: ${RUN_CRYPTOPUNKS_TIMES:=2} # якщо нема значення то присвоїти 2
RUN_ENS_TIMES=$2
: ${RUN_ENS_TIMES:=13} # якщо нема значення то присвоїти 13
RUN_BUSD_TIMES=$3
: ${RUN_BUSD_TIMES:=0} # якщо нема значення то присвоїти 0

function sleep_min () {   for((sec=0; sec<"$1"; sec++));     do       printf ".";       sleep 1m;     done;     echo " ";   }

for (( c=1; c<=$RUN_CRYPTOPUNKS_TIMES; c++ ))
do  
  echo "Run CRYPTOPUNKS $c times"
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 6'
  sleep_min 60 
  tmux kill-session -t squid_restart
done

for (( c=1; c<=$RUN_ENS_TIMES; c++ ))
do  
  echo "Run ENS $c times"
  tmux new-session -d -s squid_restart 'bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 7'
  sleep_min 60
  tmux kill-session -t squid_restart
done
