#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/reping_on_docker.sh)

function update {
  echo $PING_PORT
  echo $PORT_MAIN
  echo $PORT
  echo $PORT4
  sleep 5
  MINIMA_UID="$(cut -d':' -f3 <<<"$(``cat minima_autorun_every_day.sh | grep $PING_PORT``)")"
  echo $MINIMA_UID
  sleep 5  
  docker exec -d minima$PORT sh -c "(sleep 5; echo 'incentivecash uid:$MINIMA_UID'; sleep 5; echo 'exit') | java -cp /usr/local/minima/minima.jar org.minima.utils.MinimaRPCClient"
}

function ports01 {
  #PORTS="9001"
  PORTS="9011"
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PING_PORT=$((PORT_MAIN+4))
    PORT="482$PRE"
    PORT4=$((PORT+3))
    update
  done
}

function ports03 {
  PORTS="9003"
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PING_PORT=$((PORT_MAIN+4))
    PORT="484$PRE"
    PORT4=$((PORT+3))
    update
  done
}

function ports05 {
  PORTS="9005"
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PING_PORT=$((PORT_MAIN+4))
    PORT="486$PRE"
    PORT4=$((PORT+3))
    update
  done
}

function ports07 {
  PORTS="9007"
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PING_PORT=$((PORT_MAIN+4))
    PORT="488$PRE"
    PORT4=$((PORT+3))
    update
  done
}
function ports09 {
  PORTS="9009"
  for PORT_MAIN in ${PORTS}
  do
    PRE=${PORT_MAIN:(-2)}
    PING_PORT=$((PORT_MAIN+4))
    PORT="489$PRE"
    PORT4=$((PORT+3))
    update
  done
}



ports01
#ports03
#ports05
#ports07
#ports09
