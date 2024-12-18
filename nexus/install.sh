#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nexus/install.sh)

# echo "-----------------------------------------------------------------------------"
# curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
# echo "-----------------------------------------------------------------------------"


NEXUS_HOME=$HOME/.nexus

# while [ -z "$NONINTERACTIVE" ] && [ ! -f "$NEXUS_HOME/prover-id" ]; do
#     read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
#     case $yn in
#         [Nn]* ) exit;;
#         [Yy]* ) break;;
#         "" ) break;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

# git --version 2>&1 >/dev/null
# GIT_IS_AVAILABLE=$?
# if [ $GIT_IS_AVAILABLE != 0 ]; then
#   echo Unable to find git. Please install it and try again.
#   exit 1;
# fi

PROVER_ID=$(cat $NEXUS_HOME/prover-id 2>/dev/null)
if [ -z "$NONINTERACTIVE" ] && [ "${#PROVER_ID}" -ne "28" ]; then
    echo To receive credit for proving in Nexus testnets, click on your prover id
    echo "(bottom left) at https://beta.nexus.xyz/ to copy the full prover id and"
    echo paste it here. Press Enter to continue.
    read -p "Prover Id (optional)> " PROVER_ID </dev/tty
    while [ ! ${#PROVER_ID} -eq "0" ]; do
        if [ ${#PROVER_ID} -eq "28" ]; then
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo Copying $NEXUS_HOME/prover-id to $NEXUS_HOME/prover-id.bak
                cp $NEXUS_HOME/prover-id $NEXUS_HOME/prover-id.bak
            fi
            echo "$PROVER_ID" > $NEXUS_HOME/prover-id
            echo Prover id saved to $NEXUS_HOME/prover-id.
            break;
        else
            echo Unable to validate $PROVER_ID. Please make sure the full prover id is copied.
        fi
        read -p "Prover Id (optional)> " PROVER_ID </dev/tty
    done
fi

function install_cargo {
    if ! type "cargo" > /dev/null; then
        echo -e "${YELLOW}cargo installing...${NORMAL}"
        sudo apt install -y protobuf-compiler 
        bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/rust.sh)
    else
        echo -e "${YELLOW}cargo installed.${NORMAL}"
    fi
}

# install_cargo
sudo apt install -y protobuf-compiler 
rustc --version || curl https://sh.rustup.rs -sSf | sh

REPO_PATH=$NEXUS_HOME/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

(cd $REPO_PATH/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)

