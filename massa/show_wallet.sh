#/bin/bash
 
source .profile
rm -f $HOME/massa/massa-client/massa-client &>/dev/null
if [ ! -e $HOME/massa/massa-client/massa-client ]; then
  wget https://raw.githubusercontent.com/razumv/helpers/main/massa/massa-client -O $HOME/massa/massa-client/massa-client &>/dev/null
  chmod +x $HOME/massa/massa-client/massa-client
fi

cd $HOME/massa/massa-client
echo massa_wallet_address=$(./massa-client wallet_info -p nodesup | grep Address | awk '{ print $2 }')
