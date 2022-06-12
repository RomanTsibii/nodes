#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/subspace/update.sh)

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/razumv/helpers/main/doubletop.sh | bash
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function get_vars {
  export CHAIN="gemini-1"
  export RELEASE="gemini-1b-2022-jun-10"
  export SUBSPACE_NODENAME=$(cat $HOME/subspace_docker/docker-compose.yml | grep "\-\-name" | awk -F\" '{print $4}')
  export WALLET_ADDRESS=$(cat $HOME/subspace_docker/docker-compose.yml | grep "\-\-reward-address" | awk -F\" '{print $4}')
}

function eof_docker_compose {
  sudo tee <<EOF >/dev/null $HOME/subspace_docker/docker-compose.yml
  version: "3.7"
  services:
    node:
      image: ghcr.io/subspace/node:$RELEASE
      volumes:
        - node-data:/var/subspace:rw
      ports:
        - "0.0.0.0:39333:30333"
      restart: unless-stopped
      command: [
        "--chain", "$CHAIN",
        "--base-path", "/var/subspace",
        "--execution", "wasm",
        "--pruning", "1024",
        "--keep-blocks", "1024",
        "--port", "30333",
        "--rpc-cors", "all",
        "--rpc-methods", "safe",
        "--unsafe-ws-external",
        "--validator",
        "--name", "$SUBSPACE_NODENAME",
        "--telemetry-url", "wss://telemetry.subspace.network/submit 0",
        "--telemetry-url", "wss://telemetry.postcapitalist.io/submit 0",
        "--reserved-nodes", "/dns/bootstrap-0.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWF9CgB8bDvWCvzPPZrWG3awjhS7gPFu7MzNPkF9F9xWwc",
        "--reserved-nodes", "/dns/bootstrap-1.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWLrpSArNaZ3Hvs4mABwYGDY1Rf2bqiNTqUzLm7koxedQQ",
        "--reserved-nodes", "/dns/bootstrap-2.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWNN5uuzPtDNtWoLU28ZDCQP7HTdRjyWbNYo5EA6fZDAMD",
        "--reserved-nodes", "/dns/bootstrap-3.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWM47uyGtvbUFt5tmWdFezNQjwbYZmWE19RpWhXgRzuEqh",
        "--reserved-nodes", "/dns/bootstrap-4.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWNMEKxFZm9mbwPXfQ3LQaUgin9JckCq7TJdLS2UnH6E7z",
        "--reserved-nodes", "/dns/bootstrap-5.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWFfEtDmpb8BWKXoEAgxkKAMfxU2yGDq8nK87MqnHvXsok",
        "--reserved-nodes", "/dns/bootstrap-6.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWHSeob6t43ukWAGnkTcQEoRaFSUWphGDCKF1uefG2UGDh",
        "--reserved-nodes", "/dns/bootstrap-7.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWKwrGSmaGJBD29agJGC3MWiA7NZt34Vd98f6VYgRbV8hH",
        "--reserved-nodes", "/dns/bootstrap-8.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWCXFrzVGtAzrTUc4y7jyyvhCcNTAcm18Zj7UN46whZ5Bm",
        "--reserved-nodes", "/dns/bootstrap-9.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWNGxWQ4sajzW1akPRZxjYM5TszRtsCnEiLhpsGrsHrFC6",
        "--reserved-nodes", "/dns/bootstrap-10.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWNGf1qr5411JwPHgwqftjEL6RgFRUEFnsJpTMx6zKEdWn",
        "--reserved-nodes", "/dns/bootstrap-11.gemini-1b.subspace.network/tcp/30333/p2p/12D3KooWM7Qe4rVfzUAMucb5GTs3m4ts5ZrFg83LZnLhRCjmYEJK"#,
        # "--reserved-nodes", "/ip4/65.21.227.181/tcp/30333/p2p/12D3KooWNUWw6VAwey273vXgYxwr7fYRm2MMFWmSXrctA7ns1Vvb",
        # "--reserved-only"
      ]
      healthcheck:
        timeout: 5s
        interval: 30s
        retries: 5

    farmer:
      depends_on:
        - node
      image: ghcr.io/subspace/farmer:$RELEASE
      volumes:
        - farmer-data:/var/subspace:rw
      restart: unless-stopped
      command: [
        "--base-path", "/var/subspace",
        "farm",
        "--node-rpc-url", "ws://node:9944",
        "--ws-server-listen-addr", "0.0.0.0:9955",
        "--reward-address", "$WALLET_ADDRESS",
        "--plot-size", "30G"
      ]
  volumes:
    node-data:
    farmer-data:
EOF
}

function update_subspace {
  cd $HOME/subspace_docker/
  docker-compose down
  # docker volume rm subspace_docker_subspace-farmer subspace_docker_subspace-node
  # docker volume rm subspace_docker_farmer-data subspace_docker_node-data
  eof_docker_compose
  docker-compose pull
  docker-compose up -d
}

colors
line
logo
line
get_vars
update_subspace
echo -e "${GREEN}=== DONE ===${NORMAL}"
