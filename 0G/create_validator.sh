#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/0G/create_validator.sh)
# і у файл seed_data.txt  (сід сід сід сід | нік_нейм)
# Перевірка, чи передано два аргументи (токен бота і chat_id)
if [ "$#" -ne 2 ]; then
    echo "Помилка: потрібно передати два параметри: <токен бота> <chat_id>"
    exit 1
fi

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

# Шлях до файлу з сід-фразами та іменами вузлів
SEED_FILE="seed_data.txt"

# Перевіряємо, чи файл існує
if [ ! -f "$SEED_FILE" ]; then
    echo "Помилка: файл $SEED_FILE не знайдено."
    exit 1
fi

# Цикл для обробки кожного рядка з файлу
while IFS='|' read -r seed OG_NODENAME; do
    seed=$(echo "$seed" | xargs)  # Видаляємо зайві пробіли
    OG_NODENAME=$(echo "$OG_NODENAME" | xargs)  # Видаляємо зайві пробіли
    echo "Обробка валідатора: $OG_NODENAME з сід-фразою: $seed"

    # Зупиняємо сервіс
    sudo systemctl stop 0g

    # Виконуємо reset Tendermint
    0gchaind tendermint unsafe-reset-all
    # rm -rf $HOME/.0gchain/data

    # Завантажуємо та розпаковуємо snapshot
    # curl https://server-5.itrocket.net/testnet/og/og_2024-09-20_1142635_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.0gchain
    lz4 -dc og_2024-09-21_1161268_snap.tar.lz4 | tar -xf - -C $HOME/.0gchain

    # Запускаємо сервіс
    sudo systemctl start 0g

    sleep 20
    # Відновлення гаманця за допомогою сід-фрази
    recover_wallet_with_seed "$seed"

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
        send_telegram_message "Валідатор *$OG_NODENAME* успішно створено | txhash: https://testnet.0g.explorers.guru/transaction/$TX_HASH"
    else
        # Повідомлення в Telegram про помилку
        send_telegram_message "Помилка при створенні валідатора *$OG_NODENAME*"
    fi

    # Затримка перед обробкою наступного валідатора (якщо потрібно)
    sleep 25

done < "$SEED_FILE"
