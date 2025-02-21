#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/start_checker.sh)
# видалити кронтаб
crontab -l | grep -v '/root/nexus_checker.sh' | crontab -

curl -o /root/nexus_checker.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/nexus/nexus_checker.sh

chmod +x /root/nexus_checker.sh

if ! crontab -l 2>/dev/null | grep -q '^SHELL=/bin/bash'; then
    (crontab -l 2>/dev/null; echo "SHELL=/bin/bash") | crontab -
fi

(crontab -l 2>/dev/null; echo "*/10 * * * * /root/nexus_checker.sh >> /var/log/nexus_checker.log 2>&1") | crontab -

/root/nexus_checker.sh >> /var/log/nexus_checker.log
