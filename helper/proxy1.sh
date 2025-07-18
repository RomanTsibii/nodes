#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/helper/proxy1.sh)

sudo systemctl stop 3proxy.service
sudo systemctl disable 3proxy.service

apt update
apt-get install build-essential -y
wget -O 0.9.3.tar.gz https://github.com/z3APA3A/3proxy/archive/0.9.3.tar.gz
tar xzf 0.9.3.tar.gz
cd 3proxy-*
sed -i '1s/^/#define ANONYMOUS 1\n/' ./src/proxy.h
make -f Makefile.Linux
mkdir -p /var/log/3proxy
mkdir /etc/3proxy
cp bin/3proxy /usr/bin/


sudo tee <<EOF >/dev/null /etc/3proxy/3proxy.cfg
nserver 8.8.8.8
nserver 8.8.4.4
nserver 1.1.1.1
nserver 1.0.0.1

nscache 65536
timeouts 1 5 30 60 180 1800 15 60

external `curl -4 -s ifconfig.me`
internal `curl -4 -s ifconfig.me`

daemon

log /var/log/3proxy/3proxy.log D
logformat "- +_L%t.%. %N.%p %E %U %C:%c %R:%r %O %I %h %T"
rotate 30

auth strong

allow * * * 80-88,8080-8088 HTTP
allow * * * 443,8443 HTTPS

proxy -p28386 -n -a
users nodeForceUser:CL:nodeForcepass

EOF

sudo tee <<EOF >/dev/null /etc/systemd/system/3proxy.service
[Unit]
Description=3proxy Proxy Server

[Service]
Type=simple
ExecStart=/usr/bin/3proxy /etc/3proxy/3proxy.cfg
ExecStop=/bin/kill `/usr/bin/pgrep -u proxy3`
RemainAfterExit=yes
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start 3proxy
sudo systemctl restart 3proxy
sudo systemctl enable 3proxy