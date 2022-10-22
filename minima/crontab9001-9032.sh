#!/bin/bash

# cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab9001-9032.sh > crontab9001-9032.sh && chmod +x crontab9001-9032.sh && ./crontab9001-9032.sh


echo "Set comand for running every day at 9:00 am"
echo "Example: curl 127.0.0.1:9002/incentivecash%20uid:7ef****d7-8141-4134-936d-2a0"
read COMMAND
echo $COMMAND >> minima_autorun_every_day.sh
chmod u+x minima_autorun_every_day.sh

touch minima_reping_base.sh
chmod +x minima_reping_base.sh

cat << EOF > /root/minima_reping_base.sh
#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/many_remove_and_install.sh)
EOF


(crontab -l 2>/dev/null || true; echo "0 1 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 3 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 5 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 7 * * * /root/minima_reping_base.sh") | crontab -
rm crontab9001-9032.sh
