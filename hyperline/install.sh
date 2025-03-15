#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/hyperline/install.sh) NAME PRIVATE_KEY

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Ввод данных от пользователя
# echo -e "Введите имя валидатора:"
# read NAME
# echo -e "Введите приватный ключ от EVM кошелька начиная с 0x:"
# read PRIVATE_KEY

if [ -n "$1" ]; then
  NAME="$1"
else
  read -p "Введите имя валидатора:" NAME
fi

if [ -n "$1" ]; then
  PRIVATE_KEY="$2"
else
  read -p "Enter your USER_TOKEN: " PRIVATE_KEY
fi
  
  
echo -e "${BLUE}Установка ноды Hyperlane...${NC}"

# Обновление и установка зависимостей
sudo apt update -y
# sudo apt upgrade -y

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker не установлен. Устанавливаем Docker...${NC}"
    sudo apt install docker.io -y
else
    echo -e "${GREEN}Docker уже установлен. Пропускаем установку.${NC}"
fi

# Загрузка Docker образа
docker pull --platform linux/amd64 gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0

# Создание директории
mkdir -p $HOME/hyperlane_db_base && chmod -R 777 $HOME/hyperlane_db_base

# Запуск Docker контейнера
docker run -d -it \
--name hyperlane \
--restart unless-stopped \
--mount type=bind,source=$HOME/hyperlane_db_base,target=/hyperlane_db_base \
gcr.io/abacus-labs-dev/hyperlane-agent:agents-v1.0.0 \
./validator \
--db /hyperlane_db_base \
--originChainName base \
--reorgPeriod 1 \
--validator.id "$NAME" \
--checkpointSyncer.type localStorage \
--checkpointSyncer.folder base  \
--checkpointSyncer.path /hyperlane_db_base/base_checkpoints \
--validator.key "$PRIVATE_KEY" \
--chains.base.signer.key "$PRIVATE_KEY" \
--chains.base.customRpcUrls https://base.llamarpc.com

# Заключительное сообщение
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
echo -e "${YELLOW}Команда для проверки логов:${NC}"
echo "docker logs --tail 100 -f hyperlane"
echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
