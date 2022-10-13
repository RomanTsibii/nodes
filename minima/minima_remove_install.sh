#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_remove_install.sh) -p 9001

source $HOME/.profile
pkill -9 /usr/bin/java

set -e

CLEAN_FLAG=''
PORT=''
HOME="/home/minima"


print_usage() {
  printf "Usage: Uninstalls minima: \n \t -x flag enable clean flag \n \t -p minima port to use eg. -p 9121"
}

while getopts ':xp:' flag; do
  case "${flag}" in
    x) CLEAN_FLAG='true';;
    p) PORT="${OPTARG}";;
    *) print_usage
       exit 1 ;;
  esac
done


echo "Stopping minima service"
systemctl stop minima_$PORT
echo "Disabling minima service"
systemctl disable minima_$PORT




echo "Removing /etc/cron.daily/minima_$PORT"
rm -f /etc/cron.daily/minima_$PORT


echo "Removing /etc/cron.weekly/minima_$PORT"
rm -f /etc/cron.weekly/minima_$PORT



rm /etc/systemd/system/minima_$PORT.service
systemctl daemon-reload
systemctl reset-failed

echo "Removing $HOME/minima_service.sh"
rm -f $HOME"/minima_service.sh"


echo "Removing data directory $HOME/.minima_$PORT"
rm -rf $HOME/.minima_$PORT

echo "install mimima"
bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_setup.sh) -p $PORT

$(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
