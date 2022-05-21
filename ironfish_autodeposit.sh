i=0
 
while true
do
   date +"%T"
   docker exec ironfish ./bin/run deposit --confirm 
   let i++
   sleep 5m
done
