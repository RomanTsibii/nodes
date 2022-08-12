#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/ping_all2.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function some_speeping {
  echo 'sleep'
  
  # min1=journalctl -u minima_${PORT} -n 5
  
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

# function ping {
#   for PORT in ${PORTS} ; do
#     echo "ping minima_${PORT}"
#     # sleep 20
#     status=$(`cat minima_autorun_every_day.sh | grep $((PORT+1))`)
#     echo $status
#     while [ echo $status == *"curl: (7) Failed to connect to 127.0.0.1 port"* ]
#     do
#       echo "Wait minima_${PORT}"
#       sleep 5
#       $status
#     done
#     printf "\nSuccess minima_${PORT}\n"
#   done
# }

function ping {
  for PORT in ${PORTS} ; do
    echo "ping minima_${PORT}"
    $(`cat minima_autorun_every_day.sh | grep $((PORT+1))`)
  done
}

function stop {
  echo "stop minima_${PORTS}"
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

function ping9 {
  PORTS="3501 3503 3505 3507 3509"
  restart
  some_speeping
  ping
  stop
}

function ping10 {
  PORTS="3511 3513 3515 3517 3519"
  restart
  some_speeping
  ping
  stop
}

function ping11 {
  PORTS="3521 3523 3525 3527 3529"
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
ping9
ping10
ping11
ping0

echo DONE
