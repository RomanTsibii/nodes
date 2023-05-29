source .profile

while true 
do
  LOGS=`STAKE_SHARDEUM`
  if [[ $LOGS == *"stake: '10'"* ]]; then break ; fi
  sleep 3
done

