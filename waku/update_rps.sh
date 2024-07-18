#!/bin/bash


RPS=$1

docker-compose -f /root/nwaku-compose/docker-compose.yml down

root/nwaku-compose/.env
ETH_CLIENT_ADDRESS=

docker-compose -f /root/nwaku-compose/docker-compose.yml up -d
