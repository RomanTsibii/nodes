### nodes
# subspace 
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

# massa
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/update_11_3.sh)

cd $HOME

pkill -9 tmux 

curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/rolls.sh > rolls.sh && chmod +x rolls.sh && tmux new-session -d -s rolls './rolls.sh'

# minima
авто запит кожного дня в 10am

в скрипті потрібно вписати свій ід з сайту

history | grep "curl 127.0.0.1"

cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab.sh > minima_crontab.sh && chmod +x minima_crontab.sh && ./minima_crontab.sh && ./minima_autorun_every_day.sh
