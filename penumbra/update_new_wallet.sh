#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update_new_wallet.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)

rm -rf /root/.local/share/pcli/custody.json /root/.local/share/pcli/pcli-view.sqlite-shm
pcli init soft-kms generate
pcli view address
