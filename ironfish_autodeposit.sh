#i=0
 
#while true
#do
#   date +"%T"
#   docker exec ironfish ./bin/run deposit --confirm 
#   let i++
#   sleep 5m
#done

i=0
 
while true
do

   BALANCE=`docker exec ironfish ./bin/run  accounts:balance`
   if [[ "$BALANCE" == *"IRON 0.0000"* ]]; then 
      echo "balance is 0"
      sleep 10s
   else 
      echo "Виконуємо транзакцiю"
      docker exec ironfish ./bin/run deposit --confirm
      date +"%T"
      sleep 10s
      let i++
      echo $BALANCE
   fi 

done

