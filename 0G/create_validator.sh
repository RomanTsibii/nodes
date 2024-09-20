#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/create_validator.sh)

# Змінні для Telegram
BOT_TOKEN="$1"
CHAT_ID="$2"

# Функція для відправки повідомлення в Telegram
send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message" \
        -d parse_mode="Markdown"
}

# Функція для відновлення гаманця з сід-фразою за допомогою expect
recover_wallet_with_seed() {
    local seed_phrase=$1
    expect <<EOF
        spawn 0gchaind keys add wallet --eth --recover
        expect {
            "override the existing name wallet" {
                send "y\r"
                exp_continue
            }
            "Enter your bip39 mnemonic" {
                send "$seed_phrase\r"
            }
        }
        expect eof
EOF
}

while true; do
  # Зупиняємо сервіс
  sudo systemctl stop 0g
  
  # Виконуємо reset Tendermint
  0gchaind tendermint unsafe-reset-all
  rm -rf $HOME/.0gchain/data 

  # Завантажуємо та розпаковуємо snapshot
  curl https://server-5.itrocket.net/testnet/og/og_2024-09-20_1142635_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.0gchain

  # Запускаємо сервіс
  sudo systemctl start 0g
  
  # Повідомлення в Telegram для вводу сід-фрази
  send_telegram_message "Введіть сід-фразу від OG для відновлення:"
  
  echo "Введіть сід-фразу від OG для відновлення:"
  read OG_SEED
  
  # Викликаємо функцію для відновлення гаманця за допомогою expect
  recover_wallet_with_seed "$OG_SEED"

  # Зчитуємо назву вузла
  echo "Введите OG_NODENAME"
  read OG_NODENAME
  
  # Створення валідатора
  VALIDATOR_OUTPUT=$(0gchaind tx staking create-validator \
    --amount=100000ua0gi \
    --pubkey=$(0gchaind tendermint show-validator) \
    --moniker="$OG_NODENAME" \
    --chain-id=zgtendermint_16600-2 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation=10000 \
    --gas=auto \
    --gas-adjustment=1.6 \
    --fees=800ua0gi \
    --from=wallet \
    -y)

  # Збереження резервної копії приватного ключа валідатора
  mkdir -p backpus_0G_validators
  mv $HOME/.0gchain/config/priv_validator_key.json backpus_0G_validators/$OG_NODENAME.json

  # Витягуємо хеш транзакції (txhash)
  TX_HASH=$(echo "$VALIDATOR_OUTPUT" | grep -oP '(?<=txhash: )\w+')

  # Перевірка, чи є txhash і чи транзакція успішна (code: 0)
  if [[ $TX_HASH ]]; then
      # Надсилаємо повідомлення в Telegram про успішне створення валідатора з хешем транзакції
      send_telegram_message "Валідатор *$OG_NODENAME* успішно створено | txhash: $TX_HASH"
  else
      # Повідомлення в Telegram про помилку
      send_telegram_message "Помилка при створенні валідатора *$OG_NODENAME*"
  fi
done
