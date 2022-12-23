#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/migrate_to_docker.sh)

#bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)

PORTS="9001"
for PORT_MAIN in ${PORTS}
  
  PORT="48201"
  PORT4=$((PORT+4))
  echo $PORT
  echo $PORT4
done

#  bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT -x
# 
#  MINIMA_PASSWORD=bnbiminima
#  docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker$PORT:/home/minima/data -p $PORT-$PORT4:9001-9004 --restart unless-stopped --name minima$PORT minimaglobal/minima:latest
#  sleep 5
#  docker run -d --restart unless-stopped --name watchtower -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
#  sleep 10 
#  MINIMA_UID="$(cut -d':' -f3 <<<"$(``cat minima_autorun_every_day.sh | grep $PORT_MAIN``)")"
#  docker exec -d minima$PORT sh -c "(sleep 5; echo 'incentivecash uid:$MINIMA_UID'; sleep 5; echo 'exit') | java -cp /usr/local/minima/minima.jar org.minima.utils.MinimaRPCClient"
#done

