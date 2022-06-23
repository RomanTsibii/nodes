#!/bin/bash

source ~/.cargo/env
cd penumbra/
wallet_info=`cargo run --quiet --release --bin pcli addr show`
echo "$wallet_info" | grep 'penumbra' | awk '{print $2}'
