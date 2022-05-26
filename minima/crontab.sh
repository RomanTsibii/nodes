#BEGIN { history | grep "curl 127.0.0.1" }
awk 'BEGIN {print history | grep "curl 127.0.0.1"}'
echo "Set comand for running every day at 9:00 am"
echo "Example: 7ef****d7-8141-4134-936d-2a0"
read COMMAND
echo "curl 127.0.0.1:9002/incentivecash%20uid:$COMMAND" >> minima_autorun_every_day.sh
chmod u+x minima_autorun_every_day.sh
(crontab -l 2>/dev/null || true; echo "* 9 * * * /root/minima_autorun_every_day.sh") | crontab -
END {
  ./minima_autorun_every_day.sh
  sleep 1
  }
