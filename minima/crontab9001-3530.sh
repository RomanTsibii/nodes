#!/bin/bash

# cd ~ && curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/crontab9001-3530.sh > crontab9001-3530.sh && chmod +x crontab9001-3530.sh && ./crontab9001-3530.sh

touch minima_reping_base.sh
chmod +x minima_reping_base.sh

cat << EOF > /root/minima_reping_base.sh
#!/bin/bash
bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/ping_all2.sh)
EOF


(crontab -l 2>/dev/null || true; echo "0 1 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 3 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 5 * * * /root/minima_reping_base.sh") | crontab -
(crontab -l 2>/dev/null || true; echo "0 7 * * * /root/minima_reping_base.sh") | crontab -
rm crontab9001-3530.sh
