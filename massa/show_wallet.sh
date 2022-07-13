#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/show_wallet.sh)
 
source .profile
rm -f $HOME/massa/massa-client/massa-client &>/dev/null
if [ ! -e $HOME/massa/massa-client/massa-client ]; then
  wget https://raw.githubusercontent.com/razumv/helpers/main/massa/massa-client -O $HOME/massa/massa-client/massa-client &>/dev/null
  chmod +x $HOME/massa/massa-client/massa-client
fi

cd $HOME/massa/massa-client
./massa-client wallet_info -p $massa_pass | grep Address | awk '{ print $2 }'
