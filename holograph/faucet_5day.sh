#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/holograph/faucet_5day.sh) holograph_password
# screen -S holograhp_faucet_5_days -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/holograph/faucet_5day.sh) holograph_password"
# screen -x holograhp_faucet_5_days

HOLOGRAPH_PASSWORD=$1

for i in {1..5}
do
  screen -S hol_one_time_session -dm bash -c "holograph faucet"
  sleep 30
  screen -S hol_one_time_session -X stuff 'y'
  sleep 1
  screen -S hol_one_time_session -X stuff $'\n' # press enter
  sleep 10
  screen -S hol_one_time_session -X stuff "$HOLOGRAPH_PASSWORD"
  sleep 1
  screen -S hol_one_time_session -X stuff $'\n' # press enter
  sleep 1
  screen -S hol_one_time_session -X stuff $'\e[B' # press down
  sleep 1
  screen -S hol_one_time_session -X stuff $'\e[B' # press down
  sleep 1
  screen -S hol_one_time_session -X stuff $'\n' # press enter
  sleep 10
  screen -S hol_one_time_session -X stuff 'y'
  sleep 1
  screen -S hol_one_time_session -X stuff $'\n' # press enter
  sleep 1
  sleep 24h
done


