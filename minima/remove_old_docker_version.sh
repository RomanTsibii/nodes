#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/remove_old_docker_version.sh)


function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
}

function update {
  for PORT_MAIN in ${PORT}
  do
    docker start minima$PORT_MAIN
    sleep_seconds 15
    docker rm -f `docker ps | grep $PORT_MAIN | awk '{print $1}'`
    rm -rf $HOME/minimadocker$PORT_MAIN
  done
}

function ports01 {
  PORTS="9021 9031 9041 9051 9061 9071 9081 9091"
  #PORTS=""
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PORT="482$PRE"    
    update
  done
}

function ports03 {
  PORTS="9013 9023 9033 9043 9053 9063 9073 9083 9093"
  #PORTS=""
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PORT="484$PRE"
    update
  done
}

function ports05 {
  PORTS="9015 9025 9035 9045 9055 9065 9075 9085 9095"
  #PORTS=""
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PORT="486$PRE"
    update
  done
}

function ports07 {
  PORTS="9017 9027 9037 9047 9057 9067 9077 9087 9097"
  #PORTS=""
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PORT="488$PRE"
    update
  done
}

function ports09 {
  PORTS="9019 9029 9039 9049 9059 9069 9079 9089"
  #PORTS=""
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PORT="489$PRE"
    update
  done
}

ports01
ports03
ports05
ports07
ports09


