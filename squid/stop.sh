#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/stop.sh) 

cd $HOME/my-single-proc-squid && docker-compose down
cd $HOME/my-double-proc-squid && docker-compose down
cd $HOME/my-triple-proc-squid && docker-compose down
cd $HOME/my-quad-proc-squid && docker-compose down
cd $HOME/my-snapshot-squid && docker-compose down
cd $HOME/my-cryptopunks-squid && docker-compose down
cd $HOME/my-ens-squid && docker-compose down
cd $HOME/simple-busd-subgraph && docker-compose down
