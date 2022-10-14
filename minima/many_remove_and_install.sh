#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/many_remove_and_install.sh) -p 9002

PORTS="9001 9005 9015"
for PORT in ${PORTS}
  do   
  systemctl stop minima_90*
  bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT -x
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh) -p $PORT
  echo '---------------------------------------------------------------------------------------------------------------------------------------------'
  echo "cat minima_autorun_every_day.sh | grep $((PORT+4))"
  echo '---------------------------------------------------------------------------------------------------------------------------------------------'
  for((sec=0; sec<80; sec++))
  do                   
    printf "."
    sleep 1
  done
  echo '----------------------------------------------------------------------------------------------------------------------------------------------'
  $(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
  echo '----------------------------------------------------------------------------------------------------------------------------------------------'
  systemctl stop minima_$PORT
done
echo $PORTS

