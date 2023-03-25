#!/bin/bash

BYTES=`du -s $HOME/pathfinder/pathfinder | awk '{print$1}'`
if (( $BYTES > 53687091 )); then
   echo "remove starknet DB"
   bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/starknet/starknet_remove_db.sh)
fi
