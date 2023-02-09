#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/penumbra/update.sh)

bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/penumbra/update_penumbra.sh)
pcli view address 0
pcli tx delegate 95penumbra --to penumbravalid1atdgamg8pnsy250n8ey6nczjx4qd4x9snymtzyxe8udn2mhk0ygqtrl5q2
pcli tx delegate 95penumbra --to penumbravalid1tgz4c39y22d035e0en5kmq8h7pd4skhzcthrpwfp84xthaku6q9s5ky9hj
pcli tx delegate 95penumbra --to penumbravalid153sh6sj3pvpt2z8kdf90khm87ejpk4ll4ce7fx493xcwpa3nhypsfkhrma
pcli view staked
