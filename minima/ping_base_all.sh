#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/ping_base_all.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function some_speeping {
  echo 'sleep'
  for((sec=0; sec<50; sec++))
  do
          printf "."
          sleep 1
  done
}

function restart {
  for PORT in ${PORTS} ; do
    echo "restart minima_${PORT}"
    systemctl restart minima_${PORT}
  done
}

function ping {
  for PORT in ${PORTS} ; do
    echo "ping minima_${PORT}"
    $(`cat minima_autorun_every_day.sh | grep $((PORT+1))`)
  done
}

function stop {
  echo "stop minima_${PORT}"
  systemctl stop minima_90*
  systemctl stop minima_35*
}


function ping0 {
  PORTS="9001 9003 9005 9007"
  restart
  some_speeping
  ping
  stop
}

function ping1 {
  PORTS="9009 9011 9013 9015"
  restart
  some_speeping
  ping
  stop
}

function ping2 {
  PORTS="9017 9019 9021 9023"
  restart
  some_speeping
  ping
  stop
}

function ping3 {
  PORTS="9025 9027 9029 9031"
  restart
  some_speeping
  ping
  stop
}

ping0
ping1
ping2
ping3

echo DONE
