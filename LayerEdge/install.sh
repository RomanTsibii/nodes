#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/LayerEdge/install.sh) PRIV_KEY

if [ -n "$1" ]; then
  PRIV_KEY="$1"
else
  read -p "Введите ваш приватный ключ без 0x: " PRIV_KEY
fi
# Запрашиваем приватный ключ у пользователя
 
echo -e "${BLUE}Устанавливаем зависимости...${NC}"

# Обновление и установка зависимостей
sudo apt update && sudo apt-get upgrade -y
sudo apt install -y git screen htop curl wget build-essential

git clone https://github.com/Layer-Edge/light-node.git
cd light-node

VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

if ! command -v rustc &> /dev/null; then
    echo -e "${BLUE}Rust не установлен. Устанавливаем Rust через rustup...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    echo -e "${GREEN}Rust успешно установлен.${NC}"
else
    echo -e "${BLUE}Rust уже установлен. Обновляем его через rustup update...${NC}"
    rustup update
    source $HOME/.cargo/env
    echo -e "${GREEN}Rust успешно обновлён.${NC}"
fi

curl -L https://risczero.com/install | bash
sleep 1
source "$HOME/.bashrc"
sleep 1
rzup install

# Создаем файл .env с нужным содержимым
echo "GRPC_URL=grpc.testnet.layeredge.io:9090" > .env
echo "CONTRACT_ADDR=cosmos1ufs3tlq4umljk0qfe8k5ya0x6hpavn897u2cnf9k0en9jr7qarqqt56709" >> .env
echo "ZK_PROVER_URL=http://127.0.0.1:3001" >> .env
echo "ZK_PROVER_URL=https://layeredge.mintair.xyz" >> .env
echo "API_REQUEST_TIMEOUT=100" >> .env
echo "POINTS_API=https://light-node.layeredge.io" >> .env
echo "PRIVATE_KEY='$PRIV_KEY'" >> .env

cd ~

echo -e "${BLUE}Запускаем Merkle-сервис...${NC}"

# Определяем имя текущего пользователя и его домашнюю директорию
USERNAME=$(whoami)
HOME_DIR=$(eval echo ~$USERNAME)

sudo bash -c "cat <<EOT > /etc/systemd/system/merkle.service
[Unit]
Description=Merkle Service for Light Node
After=network.target

[Service]
User=$USERNAME
Environment=PATH=$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
WorkingDirectory=$HOME_DIR/light-node/risc0-merkle-service
ExecStart=/usr/bin/env bash -c \"cargo build && cargo run --release\"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOT"

sudo systemctl daemon-reload
sleep 2
sudo systemctl enable merkle.service
sudo systemctl restart merkle.service
sudo systemctl start merkle.service
# Проверка логов
sudo journalctl -u merkle.service -f

echo -e "${BLUE}Запускаем ноду...${NC}"
USERNAME=$(whoami)
HOME_DIR=$(eval echo ~$USERNAME)

# Определяем путь к Go
GO_PATH=$(which go)

# Проверяем, что GO_PATH не пустой
if [ -z "$GO_PATH" ]; then
    echo "Go не найден в PATH. Проверьте установку Go."
    exit 1
fi

sudo bash -c "cat <<EOT > /etc/systemd/system/light-node.service
[Unit]
Description=LayerEdge Light Node Service
After=network.target

[Service]
User=$USERNAME
WorkingDirectory=$HOME_DIR/light-node
ExecStartPre=$GO_PATH build
ExecStart=$HOME_DIR/light-node/light-node
Restart=always
RestartSec=10
TimeoutStartSec=200

[Install]
WantedBy=multi-user.target
EOT"

sudo systemctl daemon-reload
sleep 2
sudo systemctl enable light-node.service
sudo systemctl restart light-node.service
sudo systemctl start light-node.service

# Заключительный вывод
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
echo -e "${YELLOW}Команда для проверки логов:${NC}"
echo "sudo journalctl -u light-node.service -f"
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
sleep 2
