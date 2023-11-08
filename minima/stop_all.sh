#!/bin/sh
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/stop_all.sh)

docker ps | grep minima
PORTS="9001 48201 48403 48605 48807 48909 48211 48413 48615 48817 48919 48221 48423 48625 48827 48929 48231 48433 48635 48837 48939 48241 48443 48645 48847 48949 48251 48453 48655 48857 48959 48261 48463 48665 48867 48969 48271 48473 48675"
function stop_all {
  for PORT in ${PORTS} ; do
    docker stop minima${PORT} &>/dev/null
  done
}

docker stop watchtower

stop_all
docker ps | grep minima
