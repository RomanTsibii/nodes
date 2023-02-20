#!/bin/bash

source $HOME/.profile
cd $HOME/massa/massa-client
candidate_rolls=$(./massa-client --pwd $massa_pass wallet_info | grep "Rolls")
echo $candidate_rolls
