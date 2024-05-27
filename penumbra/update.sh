#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)

screen -S synk_penumbra -dm bash -c "pcli view staked"
