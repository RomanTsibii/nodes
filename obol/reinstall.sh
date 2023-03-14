#!/bin/bash

# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/obol/reinstall.sh)

mkdir $HOME/backup_obol
cp -r $HOME/charon-distributed-validator-node/.charon/ $HOME/backup_obol
docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml down -v

docker rmi -f $(docker images | grep ethereum/client | awk '{print$3}')
docker rmi $(docker images | grep sigp/lighthouse | awk '{print$3}')
docker rmi -f $(docker images | grep obolnetwork/charon | awk '{print$3}')
docker rmi $(docker images | grep consensys/teku | awk '{print$3}')
docker rmi -f $(docker images | grep prom | awk '{print$3}')
docker rmi -f $(docker images | grep grafana/grafana | awk '{print$3}')

rm -rf $HOME/charon-distributed-validator-node
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git
cd $HOME/charon-distributed-validator-node/

git checkout -- $HOME/charon-distributed-validator-node/docker-compose.yml
cp $HOME/charon-distributed-validator-node/.env.sample $HOME/charon-distributed-validator-node/.env
echo -e "\nGETH_PORT_HTTP=18545" >> $HOME/charon-distributed-validator-node/.env
echo -e "\nLIGHTHOUSE_PORT_P2P=19000" >> $HOME/charon-distributed-validator-node/.env
echo -e "\nMONITORING_PORT_GRAFANA=4000" >> $HOME/charon-distributed-validator-node/.env
echo -e "\nCHARON_P2P_EXTERNAL_HOSTNAME=$(curl -s [ifconfig.me](http://ifconfig.me/))" >> $HOME/charon-distributed-validator-node/.env
sed -i -e 's/9100:9100/19100:9100/' $HOME/charon-distributed-validator-node/docker-compose.yml
mkdir $HOME/charon-distributed-validator-node/.charon/
cp -r $HOME/backup_obol/.charon $HOME/charon-distributed-validator-node/chmod o+rw -R $HOME/charon-distributed-validator-node
sudo chown -R 1000:1000 $HOME/charon-distributed-validator-node/.charon/

docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml up -d

echo "docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml logs -f --tail=100"
echo "docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml logs -f --tail=100 geth"

#docker rmi -f $(docker images | grep obol | awk '{print$3}')
#docker rmi $(docker images | grep teku | awk '{print$3}')
#docker rmi $(docker images | grep grafana/grafana | awk '{print$3}')
#docker rmi $(docker images | grep sigp/lighthouse | awk '{print$3}')
#docker rmi -f $(docker images | grep prom | awk '{print$3}')
#docker rmi -f $(docker images | grep all-in-one | awk '{print$3}')


#
#Creating charon-distributed-validator-node_geth_1       ... done
#Creating charon-distributed-validator-node_charon_1     ... done
#Creating charon-distributed-validator-node_teku_1       ... done
#Creating charon-distributed-validator-node_grafana_1    ... done
#Creating charon-distributed-validator-node_lighthouse_1 ... done
#Creating charon-distributed-validator-node_prometheus_1 ... done

#Pulling geth (ethereum/client-go:v1.11.4)...
#Pulling lighthouse (sigp/lighthouse:v3.5.1)...
#Pulling charon (obolnetwork/charon:v0.14.1)...
#Pulling teku (consensys/teku:23.3.0)...
#Pulling prometheus (prom/prometheus:v2.42.0)...
#Pulling grafana (grafana/grafana:9.4.3)...



