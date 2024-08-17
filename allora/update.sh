#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/allora/update.sh)


echo "Введите сид фразу от кошелька, который будет использоваться для воркера"
read WALLET_SEED_PHRASE


docker compose -f $HOME/nwaku-compose/docker-compose.yml down -v


cd basic-coin-prediction-node
docker compose down -v
docker stop $(docker ps -a | grep basic-coin-prediction-node-updater | awk '{print $1}') $(docker ps -a | grep basic-coin-prediction-node-inference | awk '{print $1}')  $(docker ps -a | grep alloranetwork | awk '{print $1}')
docker rm $(docker ps -a | grep basic-coin-prediction-node-updater | awk '{print $1}') $(docker ps -a | grep basic-coin-prediction-node-inference | awk '{print $1}')  $(docker ps -a | grep alloranetwork | awk '{print $1}')
cd $HOME && rm -rf basic-coin-prediction-node


cd $HOME
git clone https://github.com/allora-network/basic-coin-prediction-node
cd basic-coin-prediction-node

echo '{
    "wallet": {
        "addressKeyName": "testkey",
        "addressRestoreMnemonic": "Seed Phrase",
        "alloraHomeDir": "",
        "gas": "1000000",
        "gasAdjustment": 1.0,
        "nodeRpc": "https://allora-rpc.testnet-1.testnet.allora.network/",
        "maxRetries": 1,
        "delay": 1,
        "submitTx": false
    },
    "worker": [
        {
            "topicId": 1,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 2,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 7,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        }
    ]
}' > config.json



sed -i "s|Seed Phrase|$WALLET_SEED_PHRASE|" $HOME/basic-coin-prediction-node/config.json


chmod +x init.config
./init.config



# sed -i "s|intervals = [\"1d\"]|intervals = [\"10m\", \"20m\", \"1h\", \"1d\"]|" $HOME/basic-coin-prediction-node/model.py
sed -i 's/intervals = \["1d"\]/intervals = ["10m", "20m", "1h", "1d"]/g' $HOME/basic-coin-prediction-node/model.py


docker compose up -d --build


