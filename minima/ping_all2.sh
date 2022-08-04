#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/ping_all2.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function some_speeping {
  echo 'sleep'
  for((sec=0; sec<100; sec++))
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
  PORTS="9001 9003 9005 9007 9009"
  restart
  some_speeping
  ping
  stop
}

function ping1 {
  PORTS="9011 9013 9015 9017 9019"
  restart
  some_speeping
  ping
  stop
}

function ping2 {
  PORTS="9021 9023 9025 9027 9029"
  restart
  some_speeping
  ping
  stop
}

function ping3 {
  PORTS="9031 9033 9035 9037 9039"
  restart
  some_speeping
  ping
  stop
}

function ping4 {
  PORTS="9041 9043 9045 9047 9049"
  restart
  some_speeping
  ping
  stop
}

function ping4 {
  PORTS="9041 9043 9045 9047 9049"
  restart
  some_speeping
  ping
  stop
}

function ping5 {
  PORTS="9051 9053 9055 9057 9059"
  restart
  some_speeping
  ping
  stop
}

function ping6 {
  PORTS="9061 9063 9065 9067 9069"
  restart
  some_speeping
  ping
  stop
}

function ping7 {
  PORTS="9071 9073 9075 9077 9079"
  restart
  some_speeping
  ping
  stop
}

function ping8 {
  PORTS="9081 9083 9085 9087"
  restart
  some_speeping
  ping
  stop
}

ping0
ping1
ping2
ping3
ping4
ping5
ping6
ping7
ping8

echo DONE
