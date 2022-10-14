#!/bin/sh
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/many_installling.sh)

PORTS="9001 9003 9005 9007 9009 9011 9013 9015 9017 9019 "
for PORT in ${PORTS} ; do
  echo "ping minima_${PORT}"
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh) -p $PORT
  systemctl disable minima_${PORT}
  systemctl stop minima_${PORT}
done
