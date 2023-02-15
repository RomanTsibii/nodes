#/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/speed_bootstrap.sh)

sed -i '/alias client/d' $HOME/.profile
source $HOME/.profile
echo "alias client='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile
echo "alias clientw='cd $HOME/massa/massa-client/ && $HOME/massa/massa-client/massa-client --pwd $massa_pass && cd'" >> ~/.profile

config_path="$HOME/massa/massa-node/base_config/config.toml"
sed -i -e "s%retry_delay *=.*%retry_delay = 15000%; " "$config_path"
sudo systemctl restart massa
