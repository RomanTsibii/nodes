#!/bin/bash
########### bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/many_remove_and_install2.sh)

PORTS="9007 9009 9011 9013 9015 9017 9019 9021 9023 9025 9027 9029 9031 9033 9035 9037 9039 9041 9043 9045 9047 9049 9051 9053 9055 9057 9059 9061 9063 9065 9067 9069 9071 9073 9075 9077 9079 9081 9083 9085 9087 3501 3503 3505 3507 3509 3511 3513 3515 3517 3519 3521 3523 3525 3527 3529 3531"
echo $PORTS
sudo apt update
docker stop  minima9001
for PORT in ${PORTS}
  do   
  systemctl stop minima_90*
  # bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT -x
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh) -p $PORT
  
  echo '----------------------------------------------------------------------------'
  echo "cat minima_autorun_every_day.sh | grep $((PORT+4))"
  echo '----------------------------------------------------------------------------'
  for((sec=0; sec<80; sec++))
  do                   
    printf "."
    sleep 1
  done
  echo '----------------------------------------------------------------------------'
  $(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
  echo '----------------------------------------------------------------------------'
  bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT
done

docker start minima9001
