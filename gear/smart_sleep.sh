# 1 - спосіб
while true 
do
  LOGS=`journalctl -n 5 -u gear`
  if [[ $LOGS == *"Syncing"* || $LOGS == *"якийсь інший вивід з логів"* ]]; then break ; fi
  sleep_seconds 3
done

# 2 - спосіб
for I in 1 2 3 4 5 6 7 8 9 10
do
  LOGS=`journalctl -n 5 -u gear`
  if [[ $LOGS == *"Syncing"* || $LOGS == *"якийсь інший вивід з логів"* ]]; then break ; fi 
  sleep_seconds 4
done
