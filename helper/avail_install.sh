#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_install.sh) 

sudo apt install ncdu tmux htop screen -y


# roman-ubuntu@server-main ssh 
mkdir -p ~/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRQQPpkvAkJVc8gBpgtQbH1LLQbg2RSI9vv9ZhPCamzZZv+AP0JXbBYhWIqUn/Wiw+XyGKRH827/NCPdo4UITdRfuAqyD8+9CtlVk1OXRsG1Q8gqCjnNrSPR1HFxtBLehz0xko18fJB2n9tqH9AopZvGBelXl69iybn0Jak36U6pdOPvmuLckvGoIrF4IKusx0H+lr80yZeV5IWJQgYsElFoLo3daAZFYyAdvaD7q4NN9F6IqgaD9hH3/msqYXe77/XSG4QUZq/VNj/8RQ9LOv9f8RSGhtIX4ayYEBfFzhfxkivyOHMDSPXXq68xJ4JHP0skeZ0RswhhR8EVlFRM55Wjk8qkl7G2LSItQwu/YF1rwpHu6Esx+CDGs5lR9xASFeQQfLHdVE8eImWLDgJQp1j+hf1X37kBXnGUFm5Yg2IJ3Rwf0YA+h6pJWwshV1cnqqrnRrkQHp2uCDYkk+DDUtbR39QRadjIyuDIXTwuKyugeJwg01D1aoR8bFNRFSZrc= ubuntu@ro_server_main >> ~/.ssh/authorized_keys
source $HOME/.profile
HOSTNAME=$(hostname -I | awk '{ print $1 }')
function send_message {
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$1" -d parse_mode="markdown" > /dev/null
}

screen -S avail -X quit
screen -dmS avail -L
screen -S avail -X colon "logfile flush 0^M"  
screen -S avail -X stuff "curl -sL1 avail.sh | bash"
screen -S avail -X stuff $'\n' # press enter
sleep 30
PUBLIC=$(tail -n 1000 screenlog.0 | grep "public key:"  | awk '{print $11}')
send_message "Node #Avail installed. On server *$HOSTNAME* to.%0AYou public key *$PUBLIC*"

screen -S avail_helscheck -dm bash -c "bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/avail_helscheck.sh) "
