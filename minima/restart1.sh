#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/restart1.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function restart {
  echo 'kill /usr/bin/java'

  echo 'restart minima_9001'
  systemctl restart minima_9001

  echo 'restart minima_9003'
  systemctl restart minima_9003

  echo 'restart minima_9005'
  systemctl restart minima_9005

  echo 'restart minima_9007'
  systemctl restart minima_9007

  echo 'restart minima_9009'
  systemctl restart minima_9009

}

function wait {
  echo 'sleep'
  for((sec=0; sec<60; sec++))
  do
          printf "."
          sleep 1
  done
}

function ping {
  /$HOME/minima_autorun_every_day.sh
}

function stop {
echo 'stop minima_9003'
systemctl stop minima_9003

echo 'stop minima_9005'
systemctl stop minima_9005

echo 'stop minima_9007'
systemctl stop minima_9007

echo 'stop minima_9009'
systemctl stop minima_9009
}

restart
wait
ping
stop

echo DONE
