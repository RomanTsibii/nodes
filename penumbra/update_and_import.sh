#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update_and_import.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)
pcli --version

mv $HOME/.local/share/pcli $HOME/.local/share/pcli.old
pcli init soft-kms import-phrase

pcli view address

tmux new-session -d -s penymbra_sync 'pcli view balance'
