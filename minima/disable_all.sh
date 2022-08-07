#!/bin/sh
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/disable_all.sh)
# sudo kill -9 `sudo lsof -t -i:9001`

PORTS="9001 9003 9005 9007 9009 9010 9011 9013 9015 9017 9019 9021 9023 9025 9027 9029 9031 9033 9035 9037 9039 9041 9043 9045 9047 9049 9051 9053 9055 9057 9059 9061 9063 9065 9067 9069 9071 9073 9075 9077 9079 9081 9083 9085 9087 3501 3503 3505 3507 3509 3511 3513 3515 3517 3519 3521 3523 3525 3527 3529"
function disable_all {
  for PORT in ${PORTS} ; do
    echo "disable minima_${PORT}"
    systemctl disable minima_${PORT}
  done
}

disable_all
