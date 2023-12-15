#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/squid/change_RPS.sh) FOLDER RPS

RPS="$2"


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

if [ "$1" -eq "8" ]
then
  FOLDER_SQUID="simple-busd-subgraph"
fi

config_path="$HOME/$FOLDER_SQUID/docker-compose.yml"
sed -i "/RPC_URL:/c\      RPC_URL: $RPS" "$config_path"
cat $config_path | grep RPC_URL:
