#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 1 2 3 4 5 6 7
# start with params (1 or 2 or 3 or 4)

echo $1

cd $HOME/my-single-proc-squid && docker-compose down
cd $HOME/my-double-proc-squid && docker-compose down
cd $HOME/my-triple-proc-squid && docker-compose down
cd $HOME/my-quad-proc-squid && docker-compose down
cd $HOME/my-snapshot-squid && docker-compose down
cd $HOME/my-cryptopunks-squid && docker-compose down
cd $HOME/my-ens-squid && docker-compose down
cd $HOME/simple-busd-subgraph && docker-compose down

if [ "$1" -eq "1" ]
then
  FOLDER_SQUID="my-single-proc-squid"
fi

if [ "$1" -eq "2" ]
then
  FOLDER_SQUID="my-double-proc-squid"
fi

if [ "$1" -eq "3" ]
then
  FOLDER_SQUID="my-triple-proc-squid"
fi

if [ "$1" -eq "4" ]
then
  FOLDER_SQUID="my-quad-proc-squid"
fi

if [ "$1" -eq "5" ]
then
  FOLDER_SQUID="my-snapshot-squid"
fi

if [ "$1" -eq "6" ]
then
  FOLDER_SQUID="my-cryptopunks-squid"
fi

if [ "$1" -eq "7" ]
then
  FOLDER_SQUID="my-ens-squid"
fi

cd $HOME/$FOLDER_SQUID
docker-compose up -d
npm ci
sqd build
sqd migration:apply
sqd run .
