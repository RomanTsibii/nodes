#!/bin/sh
#sudo kill -9 `sudo lsof -t -i:9001`



function stop1 {
  echo 'stop minima_9003'
  systemctl stop minima_9003

  echo 'stop minima_9005'
  systemctl stop minima_9005

  echo 'stop minima_9007'
  systemctl stop minima_9007

  echo 'stop minima_9009'
  systemctl stop minima_9009
}

function stop2 {
  echo 'stop minima_9011'
  systemctl stop minima_9011

  echo 'stop minima_9013'
  systemctl stop minima_9013

  echo 'stop minima_9015'
  systemctl stop minima_9015

  echo 'stop minima_9017'
  systemctl stop minima_9017

  echo 'stop minima_9019'
  systemctl stop minima_9019
}

function stop3 {
  echo 'stop minima_9021'
  systemctl stop minima_9021

  echo 'stop minima_9023'
  systemctl stop minima_9023

  echo 'stop minima_9025'
  systemctl stop minima_9025

  echo 'stop minima_9027'
  systemctl stop minima_9027

  echo 'stop minima_9029'
  systemctl stop minima_9029
}

stop1
stop2
stop3
systemctl stop minima_9031
systemctl stop minima_9033

rm -rf /home/minima/


https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/install_more1.sh
wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9002 -p 9001
sleep 10
systemctl stop minima_9001

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9004 -p 9003
sleep 10
systemctl stop minima_9003

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9006 -p 9005
sleep 10
systemctl stop minima_9005

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9008 -p 9007
sleep 10
systemctl stop minima_9007

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9010 -p 9009
sleep 10
systemctl stop minima_9009

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9012 -p 9011
sleep 10
systemctl stop minima_9011

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9014 -p 9013
sleep 10
systemctl stop minima_9013

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9016 -p 9015
sleep 10
systemctl stop minima_9015

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9018 -p 9017
sleep 10
systemctl stop minima_9017

wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9020 -p 9019
sleep 10
systemctl stop minima_9019

# wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9022 -p 9021
# sleep 10
# systemctl stop minima_9021
# wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9024 -p 9023
# sleep 10
# systemctl stop minima_9023
# wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9026 -p 9025
# sleep 10
# systemctl stop minima_9025
# wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9028 -p 9027
# sleep 18
# systemctl stop minima_9027
# wget -O minima_setup.sh https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh && chmod +x minima_setup.sh && sudo ./minima_setup.sh -r 9030 -p 9029
# sleep 10
# systemctl stop minima_9029

echo "install more is DONE"
