#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/reping_all_5_2.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function some_speeping {
  echo 'sleep'
  
  # min1=journalctl -u minima_${PORT} -n 5
  
  for((sec=0; sec<80; sec++))
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
    $(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
  done
}

function stop {
  echo "stop minima_${PORTS}"
  systemctl stop minima_90*
  systemctl stop minima_35*
}


function ping0 {
  PORTS="9001 9003"
  restart
  some_speeping
  ping
  stop
}

function ping1 {
  PORTS="9005 9007"
  restart
  some_speeping
  ping
  stop
}

function ping2 {
  PORTS="9009 9011"
  restart
  some_speeping
  ping
  stop
}

function ping3 {
  PORTS="9013 9015"
  restart
  some_speeping
  ping
  stop
}

function ping4 {
  PORTS="9017 9019"
  restart
  some_speeping
  ping
  stop
}

function ping5 {
  PORTS="9021 9023"
  restart
  some_speeping
  ping
  stop
}

function ping6 {
  PORTS="9025 9027"
  restart
  some_speeping
  ping
  stop
}

function ping7 {
  PORTS="9029 9031"
  restart
  some_speeping
  ping
  stop
}


function ping8 {
  PORTS="9033 9035"
  restart
  some_speeping
  ping
  stop
}

function ping9 {
  PORTS="9037 9039"
  restart
  some_speeping
  ping
  stop
}

function ping10 {
  PORTS="9041 9043"
  restart
  some_speeping
  ping
  stop
}

function ping11 {
  PORTS="9045 9047"
  restart
  some_speeping
  ping
  stop
}

function ping12 {
  PORTS="9049 9051"
  restart
  some_speeping
  ping
  stop
}

function ping13 {
  PORTS=" 9053 9055"
  restart
  some_speeping
  ping
  stop
}

function ping14 {
  PORTS="9057 9059"
  restart
  some_speeping
  ping
  stop
}

function ping15 {
  PORTS="9061 9063"
  restart
  some_speeping
  ping
  stop
}

function ping16 {
  PORTS="9065 9067"
  restart
  some_speeping
  ping
  stop
}

function ping17 {
  PORTS="9069 9071 "
  restart
  some_speeping
  ping
  stop
}

function ping18 {
  PORTS="9073 9075"
  restart
  some_speeping
  ping
  stop
}

function ping19 {
  PORTS="9077 9079"
  restart
  some_speeping
  ping
  stop
}

function ping20 {
  PORTS="9081 9083"
  restart
  some_speeping
  ping
  stop
}

function ping21 {
  PORTS="9085 9087"
  restart
  some_speeping
  ping
  stop
}

function ping22 {
  PORTS="3501 3503"
  restart
  some_speeping
  ping
  stop
}

function ping23 {
  PORTS="3505 3507"
  restart
  some_speeping
  ping
  stop
}

function ping24 {
  PORTS="3509 3511"
  restart
  some_speeping
  ping
  stop
}

function ping25 {
  PORTS="3513 3515"
  restart
  some_speeping
  ping
  stop
}

 
function ping26 {
  PORTS="3517 3519"
  restart
  some_speeping
  ping
  stop
}

function ping27 {
  PORTS="3521 3523"
  restart
  some_speeping
  ping
  stop
}

function ping28 {
  PORTS="3525 3527"
  restart
  some_speeping
  ping
  stop
}

function ping29 {
  PORTS="3529"
  restart
  some_speeping
  ping
  stop
}

function remove_all_database {
  echo 'remove minima database'
  rm -rf /home/minima/.minima_*
}

# remove_all_database
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
ping12
ping13
ping14
ping15
ping16
ping17
ping18
ping19
ping20
ping21
ping22
ping23
ping24
ping25
ping26
ping27
ping28
ping29
ping30

echo DONE
