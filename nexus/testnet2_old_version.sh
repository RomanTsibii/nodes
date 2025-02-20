#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/testnet2_old_version.sh) 

sudo apt update && sudo apt upgrade -y && \
sudo apt install -y tmux nano build-essential pkg-config libssl-dev git-all unzip python3-pexpect expect && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
source /root/.cargo/env && \
cargo --version && \
rustup target add riscv32i-unknown-none-elf && \
sudo apt remove -y protobuf-compiler && \
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip && \
unzip -o protoc-25.2-linux-x86_64.zip -d /root/.local && \
export PATH="/root/.local/bin:$PATH" && \
protoc --version

cd && rm -r .nexus

# install code
rustc --version || curl https://sh.rustup.rs -sSf | sh
NEXUS_HOME=/root/.nexus
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

[ -d $NEXUS_HOME ] || mkdir -p $NEXUS_HOME

# if [ -z "$NONINTERACTIVE" ] && [ "${#NODE_ID}" -ne "28" ]; then
#     echo "\n${ORANGE}The Nexus network is currently in Testnet II. You can now earn Nexus Points.${NC}\n\n"
# fi

# while [ -z "$NONINTERACTIVE" ] && [ ! -f "$NEXUS_HOME/node-id" ]; do
#     read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
#     echo ""
    
#     case $yn in
#         [Nn]* ) 
#             echo ""
#             exit;;
#         [Yy]* ) 
#             echo ""
#             break;;
#         "" ) 
#             echo ""
#             break;;
#         * ) 
#             echo "Please answer yes or no."
#             echo "";;
#     esac
# done

git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo Unable to find git. Please install it and try again.
  exit 1;
fi

REPO_PATH=$NEXUS_HOME/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash && git fetch --tags)
else
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi

(cd "$REPO_PATH" && git -c advice.detachedHead=false checkout tags/0.4.8) # old version

# (cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))  # new versions

cd $REPO_PATH/clients/cli
cargo run --release -- --beta

cd /root/.nexus/network-api/clients/cli/
rustup target add riscv32i-unknown-none-elf

# cargo run --release -- --start --beta

wget -O run_expect.sh https://raw.githubusercontent.com/RomanTsibii/nodes/refs/heads/main/nexus/run_expect.sh
chmod +x run_expect.sh
./run_expect.sh

# For local testing
# echo "Current location: $(pwd)"
# (cd clients/cli && cargo run --release -- --start --staging)
