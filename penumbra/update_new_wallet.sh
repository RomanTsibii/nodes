#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update_new_wallet.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)
pcli --version
rm -rf /root/.local/share/pcli/custody.json /root/.local/share/pcli/pcli-view.sqlite-shm /root/.local/share/pcli/pcli-view.sqlite-wal

pcli init soft-kms generate > penymbra.txt

pcli view address >> penymbra.txt
cat penymbra.txt
tmux new-session -d -s penymbra_sync 'pcli view balance'
