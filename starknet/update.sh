#!/bin/bash

cd $HOME/pathfinder
docker-compose down
docker-compose pull
docker-compose up -d
