#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/restart.sh) 1 2 3 4 
# start with params (1 or 2 or 3 or 4)

echo $1

cd $HOME/my-single-proc-squid && docker-compose down
cd $HOME/my-double-proc-squid && docker-compose down
cd $HOME/my-triple-proc-squid && docker-compose down
cd $HOME/my-quad-proc-squid && docker-compose down

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

cd $FOLDER_SQUID
sqd up
npm ci
sqd build
sqd migration:apply
sqd run .
