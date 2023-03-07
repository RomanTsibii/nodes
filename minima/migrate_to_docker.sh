#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/migrate_to_docker.sh)

bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p 9010 -x

function sleep_seconds () {
  for((sec=0; sec<"$1"; sec++))
    do
      printf "."
      sleep 1
    done
    echo " "
  }

function update {
  echo "$PING_PORT $PORT_MAIN $PORT $PORT4"
  MINIMA_UID="$(cut -d':' -f3 <<<"$(``cat minima_autorun_every_day.sh | grep $PING_PORT``)")"
  DOCKER_FOLDER=`ls | grep minimadocker$PORT`
  
  #  якщо є потрібний  UID в файлі і ще не встановлено на докер
  if [[ -n $MINIMA_UID && -z $DOCKER_FOLDER ]]; then
    echo "-----------------------------------------INSTALING ON PORT $PORT-----------------------------------------"
    # bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT_MAIN -x
    MINIMA_PASSWORD=bnbiminima
    docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker$PORT:/home/minima/data -p $PORT-$PORT4:9001-9004 --restart unless-stopped --name minima$PORT minimaglobal/minima:latest
    sleep_seconds 15
    echo $MINIMA_UID
    docker logs --tail=5 minima$PORT
    
    while true
    do
      LOGS=`docker logs --tail=10 minima$PORT`
      if [[ $LOGS == *"MAXIMA NEW connection"* || $LOGS == *"MAXIMA HOST accepted"* ]]; then break ; fi
      sleep_seconds 5
    done
    
    sleep_seconds 60
    docker exec -d minima$PORT sh -c "(sleep 5; echo 'incentivecash uid:$MINIMA_UID'; sleep 5; echo 'exit') | java -cp /usr/local/minima/minima.jar org.minima.utils.MinimaRPCClient"
    docker logs --tail=5 minima$PORT
    #docker stop minima$PORT
    echo "-----------------------------------------INSTALED ON PORT $PORT-----------------------------------------"
  fi
}

function ports01 {
  PORTS="9001 9011"
  #PORTS="9021 9031 9041 9051 9061 9071 9081 9091"
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
  #PORTS="9013 9023 9033 9043 9053 9063 9073 9083 9093"
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
  #PORTS="9015 9025 9035 9045 9055 9065 9075 9085 9095"
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
  #PORTS="9017 9027 9037 9047 9057 9067 9077 9087 9097"
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
  #PORTS="9019 9029 9039 9049 9059 9069 9079 9089"
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
ports03
ports05
ports07
ports09

ls | grep minimadocker

#docker run -d --restart unless-stopped --name watchtower -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
