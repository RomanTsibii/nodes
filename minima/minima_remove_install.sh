#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_remove_install.sh) -p 9001

source $HOME/.profile
pkill -9 /usr/bin/java

echo "remove mimima"
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
systemctl stop minima_9*
systemctl stop minima_3*
echo "Disabling minima service"
systemctl disable minima_9*
systemctl disable minima_3*



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
set -e

CLEAN_FLAG=''
PORT=''
HOST=''
HOME="/home/minima"
CONNECTION_HOST=''
CONNECTION_PORT=''
SLEEP=''
RPC=''

print_usage() {
  printf "Usage: Setups a new minima service for the specified port"
}

while getopts ':xsc::p:r:d:h:' flag; do
  case "${flag}" in
    s) SLEEP='true';;
    x) CLEAN_FLAG='true';;
    r) RPC="${OPTARG}";;
    c) CONNECTION_HOST=$(echo $OPTARG | cut -f1 -d:);
       CONNECTION_PORT=$(echo $OPTARG | cut -f2 -d:);;
    p) PORT="${OPTARG}";;
    d) HOME="${OPTARG}";;
    h) HOST="${OPTARG}";;
    *) print_usage
       exit 1 ;;
  esac
done

apt update
apt install openjdk-11-jre-headless curl jq -y


if [ ! $(getent group minima) ]; then
  echo "[+] Adding minima group"
  groupadd -g 9001 minima
fi

if ! id -u 9001 > /dev/null 2>&1; then
  echo "[+] Adding minima user"
    useradd -r -u 9001 -g 9001 -d $HOME minima
    mkdir $HOME
    chown minima:minima $HOME
fi

wget -q -O $HOME"/minima_service.sh" "https://raw.githubusercontent.com/minima-global/Minima/test-mdsenable-scripts/scripts/minima_service.sh"
chown minima:minima $HOME"/minima_service.sh"
chmod +x $HOME"/minima_service.sh"

CMD="$HOME/minima_service.sh -s $@"
CRONSTRING="#!/bin/sh
$CMD"

echo "$CRONSTRING" > /etc/cron.daily/minima_$PORT
chmod a+x /etc/cron.daily/minima_$PORT

CMD="$HOME/minima_service.sh $@"
/bin/sh -c "$CMD"

echo "Install complete - showing logs now -  Ctrl-C to exit logs, minima will keep running"

echo "cat minima_autorun_every_day.sh | grep $((PORT+4))"

for((sec=0; sec<30; sec++))
        do
                printf "."
                sleep 1
done
$(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
