#!/bin/bash
# Використання: bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/validator_statistic.sh) <TG_TOKEN> <TG_ID>

# Перевірка наявності аргументів для Telegram
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Використання: bash <(curl -s URL) <TG_TOKEN> <TG_ID>"
  exit 1
fi

# Змінні для Telegram
TG_TOKEN="$1"
TG_ID="$2"

# Функція для відправки повідомлень у Telegram
send_telegram_message() {
  local message="$1"
  curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
    -d chat_id="$TG_ID" \
    -d text="$message" \
    -d parse_mode="HTML" > /dev/null
}

# Отримуємо RPC порт
rpc_port=$(grep -m 1 -oP '^laddr = "\K[^"]+' "$HOME/.0gchain/config/config.toml" | cut -d ':' -f 3)

# Починаємо цикл
while true; do
  # Отримуємо висоту блоків ноди та мережі
  local_height=$(curl -s localhost:$rpc_port/status | jq -r '.result.sync_info.latest_block_height')
  network_height=$(curl -s https://api.oneiricts.com:8445/cosmos/base/tendermint/v1beta1/blocks/latest | jq -r '.block.header.height')

  # Перевіряємо коректність даних
  if ! [[ "$local_height" =~ ^[0-9]+$ ]] || ! [[ "$network_height" =~ ^[0-9]+$ ]]; then
    echo -e "\033[1;31mError: Invalid block height data. Retrying...\033[0m"
    sleep 1
    continue
  fi

  # Рахуємо кількість блоків, що залишилися для синхронізації
  blocks_left=$((network_height - local_height))
  if [ "$blocks_left" -lt 0 ]; then
    blocks_left=0
  fi

  # Виводимо інформацію на екран
  echo -e "\033[1;33mYour Node Height:\033[1;34m $local_height\033[0m \033[1;33m| Network Height:\033[1;36m $network_height\033[0m \033[1;33m| Blocks Left:\033[1;31m $blocks_left\033[0m"

  # Відправляємо повідомлення в Telegram кожні 30 хвилин
  if (( $(date +%s) % 1800 == 0 )); then
    message="⛓ <b>Your Node Height:</b> <code>$local_height</code>\n<b>Network Height:</b> <code>$network_height</code>\n<b>Blocks Left:</b> <code>$blocks_left</code>"
    send_telegram_message "$message"
  fi

  sleep 1
done
