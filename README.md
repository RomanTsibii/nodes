### nodes
# subspace 
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

# massa
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)

cd $HOME
pkill -9 tmux 
curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'
