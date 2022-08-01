#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/ping_all.sh)

source $HOME/.profile
pkill -9 /usr/bin/java

function ping1 {
  $(`cat minima_autorun_every_day.sh | grep "9002"`)
  $(`cat minima_autorun_every_day.sh | grep "9004"`)
  $(`cat minima_autorun_every_day.sh | grep "9006"`)
  $(`cat minima_autorun_every_day.sh | grep "9008"`)
  $(`cat minima_autorun_every_day.sh | grep "9010"`)
}

function ping2 {
  $(`cat minima_autorun_every_day.sh | grep "9012"`)
  $(`cat minima_autorun_every_day.sh | grep "9014"`)
  $(`cat minima_autorun_every_day.sh | grep "9016"`)
  $(`cat minima_autorun_every_day.sh | grep "9018"`)
  $(`cat minima_autorun_every_day.sh | grep "9020"`)
}

function ping3 {
  $(`cat minima_autorun_every_day.sh | grep "9022"`)
  $(`cat minima_autorun_every_day.sh | grep "9024"`)
  $(`cat minima_autorun_every_day.sh | grep "9026"`)
  $(`cat minima_autorun_every_day.sh | grep "9028"`)
  $(`cat minima_autorun_every_day.sh | grep "9030"`)
}


function restart1 {
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

function restart2 {
  echo 'restart minima_9011'
  systemctl restart minima_9011

  echo 'restart minima_9013'
  systemctl restart minima_9013

  echo 'restart minima_9015'
  systemctl restart minima_9015

  echo 'restart minima_9017'
  systemctl restart minima_9017

  echo 'restart minima_9019'
  systemctl restart minima_9019
}

function restart3 {
  echo 'restart minima_9021'
  systemctl restart minima_9021

  echo 'restart minima_9023'
  systemctl restart minima_9023

  echo 'restart minima_9025'
  systemctl restart minima_9025

  echo 'restart minima_9027'
  systemctl restart minima_9027

  echo 'restart minima_9029'
  systemctl restart minima_9029
}

function stop1 {
  echo 'stop minima_9003'
  systemctl stop minima_9003

  echo 'stop minima_9005'
  systemctl stop minima_9005

  echo 'stop minima_9007'
  systemctl stop minima_9007

  echo 'stop minima_9009'
  systemctl stop minima_9009
}

function stop2 {
  echo 'stop minima_9011'
  systemctl stop minima_9011

  echo 'stop minima_9013'
  systemctl stop minima_9013

  echo 'stop minima_9015'
  systemctl stop minima_9015

  echo 'stop minima_9017'
  systemctl stop minima_9017

  echo 'stop minima_9019'
  systemctl stop minima_9019
}

function stop3 {
  echo 'stop minima_9021'
  systemctl stop minima_9021

  echo 'stop minima_9023'
  systemctl stop minima_9023

  echo 'stop minima_9025'
  systemctl stop minima_9025

  echo 'stop minima_9027'
  systemctl stop minima_9027

  echo 'stop minima_9029'
  systemctl stop minima_9029
}

function some_speeping {
  echo 'sleep'
  for((sec=0; sec<100; sec++))
  do
          printf "."
          sleep 1
  done
}


restart1
some_speeping
ping1
stop1

restart2
some_speeping
ping1
stop2

restart3
some_speeping
ping1
stop3

echo DONE
