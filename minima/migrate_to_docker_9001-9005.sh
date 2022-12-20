#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/migrate_to_docker_9001-9005.sh)

bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p 9001 -x
bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
MINIMA_PASSWORD=bnbiminima
docker run -d -e minima_mdspassword=$MINIMA_PASSWORD -e minima_server=true -v ~/minimadocker9001:/home/minima/data -p 9001-9004:9001-9004 --restart unless-stopped --name minima9001 minimaglobal/minima:latest
MINIMA_UID="$(cut -d':' -f3 <<<"$(``cat minima_autorun_every_day.sh | grep 9005``)")"
docker exec -d minima9001 sh -c "(sleep 5; echo 'incentivecash uid:$MINIMA_UID'; sleep 5; echo 'exit') | java -cp /usr/local/minima/minima.jar org.minima.utils.MinimaRPCClient"

