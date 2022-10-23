#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/reping_9001.sh)

echo "Set comand for running every day at 9:00 am"
echo "Example: curl 127.0.0.1:9002/incentivecash%20uid:7ef****d7-8141-4134-936d-2a0"
read COMMAND
echo $COMMAND >> minima_autorun_every_day.sh
chmod u+x minima_autorun_every_day.sh

touch minima_reping_base.sh
chmod +x minima_reping_base.sh

cat << EOF > /root/minima_reping_base.sh
#!/bin/bash


PORTS="9001"
for PORT in ${PORTS}
  do   
  systemctl stop minima_90*
  bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT -x
  bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/minima_setup.sh) -p $PORT
  
  echo '---------------------------------------------------------------------------------------------------------------------------------------------'
  echo "cat minima_autorun_every_day.sh | grep $((PORT+4))"
  echo '---------------------------------------------------------------------------------------------------------------------------------------------'
  for((sec=0; sec<80; sec++))
  do                   
    printf "."
    sleep 1
  done
  echo '----------------------------------------------------------------------------------------------------------------------------------------------'
  $(`cat minima_autorun_every_day.sh | grep $((PORT+4))`)
  echo '----------------------------------------------------------------------------------------------------------------------------------------------'
  systemctl stop minima_$PORT
  bash <(curl -s https://raw.githubusercontent.com/minima-global/Minima/master/scripts/minima_remove.sh) -p $PORT -x
done

EOF


(crontab -l 2>/dev/null || true; echo "0 1 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 3 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 5 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 7 * * * /root/minima_reping_base.sh") | crontab -
rm crontab9001-9032.sh
