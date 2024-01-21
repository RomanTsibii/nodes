#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/holograph/faucet_5day.sh holograph_password)

HOLOGRAPH_PASSWORD=$1

for i in {1..5}
do
  screen -S mysession -dm bash -c "holograph faucet"
  sleep 30
  screen -S mysession -X stuff 'y'
  sleep 1
  screen -S mysession -X stuff $'\n' # press enter
  sleep 1
  screen -S mysession -X stuff "$HOLOGRAPH_PASSWORD"
  sleep 1
  screen -S mysession -X stuff $'\n' # press enter
  sleep 1
  screen -S mysession -X stuff $'\e[B' # press down
  sleep 1
  screen -S mysession -X stuff $'\e[B' # press down
  sleep 1
  screen -S mysession -X stuff $'\n' # press enter
  sleep 10
  screen -S mysession -X stuff 'y'
  sleep 1
  screen -S mysession -X stuff $'\n' # press enter
  sleep 1
done


