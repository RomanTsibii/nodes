
while true 
do
  LOGS=`journalctl -n 5 -u gear`
  if [[ $LOGS == *"Syncing"* || $LOGS == *"якийсь інший вивід з логів"* ]]; then break ; fi
  sleep_seconds 3
done
