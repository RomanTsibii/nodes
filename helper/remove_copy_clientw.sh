#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/remove_copy_clientw.sh)
 
sed -i '/alias client/d' $HOME/.profile
source $HOME/.profile
echo "alias client='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile
echo "alias clientw='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile

