source .profile

while true 
do
  LOGS=`STAKE_SHARDEUM`
  echo $LOGS
  if [[ $LOGS == *"stake: '10'"* ]]; then break ; fi
  sleep 3
done

