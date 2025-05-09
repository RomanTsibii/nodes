#/bin/bash
# cd /root/massa/massa-client && ./massa-client -p password



cd $HOME
rm -rf $HOME/massa
wget https://github.com/massalabs/massa/releases/download/MAIN.2.4/massa_MAIN.2.4_release_linux.tar.gz 
tar zxvf massa_MAIN.2.4_release_linux.tar.gz 
rm massa_MAIN.2.4_release_linux.tar.gz

sudo tee <<EOF >/dev/null /etc/systemd/system/massa.service
[Unit]
        Description=Massa Node
        After=network-online.target
[Service]
        User=root
        WorkingDirectory=/root/massa/massa-node
        ExecStart=/root/massa/massa-node/massa-node -p nodesup
        Restart=on-failure
        RestartSec=3
        LimitNOFILE=65535
[Install]
        WantedBy=multi-user.target

EOF

sudo systemctl restart systemd-journald
sudo systemctl enable massa
sudo systemctl daemon-reload
sudo systemctl restart massa

sudo journalctl -u massa -f


