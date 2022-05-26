history | grep "curl 127.0.0.1"
echo "Set your uid"
read MINIMA_UID
echo "curl 127.0.0.1:9002/incentivecash%20uid:$MINIMA_UID" >> minima_autochecking.sh
chmod u+x minima_autochecking.sh

crontab -e
1 
* 9 * * * /root/minima_autochecking.sh
