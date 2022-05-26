history | grep "curl 127.0.0.1"
sleep 1
echo "Set comand for running every day at 9:00 am"
echo "Example: curl 127.0.0.1:9002/incentivecash%20uid:7ef****d7-8141-4134-936d-2a0"
read COMMAND
echo "$COMMAND" >> minima_autochecking.sh
chmod u+x minima_autochecking.sh
(crontab -l 2>/dev/null || true; echo "* 9 * * * /root/minima_autochecking.sh" | crontab -
./minima_autochecking.sh
