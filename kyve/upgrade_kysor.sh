

wget https://github.com/KYVENetwork/kyvejs/releases/download/%40kyve%2Fkysor%401.0.0-beta.5/kysor-linux-x64.zip && \
unzip kysor-linux-x64.zip && \
mv kysor-linux-x64 kysor 

./kysor version

chmod +x kysor && \
mv kysor /usr/bin/kysor && \
rm kysor-linux-x64.zip*

nano ~/.kysor/config.toml

chainId = "korellia"
autoDownloadBinaries = true
rpc = "https://rpc.korellia.kyve.network"
rest = "https://api.korellia.kyve.network"
