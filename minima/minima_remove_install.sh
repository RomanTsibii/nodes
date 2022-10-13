#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_remove_install.sh) -p 9001

source $HOME/.profile
pkill -9 /usr/bin/java

echo "remove mimima"
bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT

echo "install mimima"
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh) -p $PORT

echo "cat minima_autorun_every_day.sh | grep $((PORT+4))"

for((sec=0; sec<30; sec++))
        do
                printf "."
                sleep 1
done
$(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
