#!/bin/bash

cd penumbra/
echo `cargo run --quiet --release --bin pcli addr show` | grep 'penumbra' | awk '{print $2}'
