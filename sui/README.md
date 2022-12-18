# Установка

## 1. Установка длится более 15 минут, рекомендуется запускать в screen сессии:
 
`screen -S sui`

## 2. Воспользуйтесь нашим скриптом для быстрой установки:

`wget -O sui_devnet.sh https://api.nodes.guru/sui_devnet.sh && chmod +x sui_devnet.sh && ./sui_devnet.sh`

Дополнительно

## 3. Проверить ноду:

`curl -s -X POST http://127.0.0.1:9000 -H 'Content-Type: application/json' -d '{ "jsonrpc":"2.0", "method":"rpc.discover","id":1}' | jq .result.info`

## 4. Проверить логи:

`journalctl -u suid -f -o cat`

# 5. Создание кошелька

### Kошелёк создаётся один раз, при обновлении сети необходимо восстановить созданный ранее.

## Для взаимодействия с блокчейном необходимо создать кошелёк, для этого нужно запустить команду ниже и ответить на вопросы:

`sui client`

`y`
`Enter`
`0`

# 6. Зберігаємо сід фразу!

https://img4.teletype.in/files/78/5e/785e6844-5264-443f-a1dd-a8d441e722d8.png


## Сделать резервную копию: Мнемонической фразы;

### Папки с ключами, сохранив её в надёжном месте (команда отображает путь):

`echo $HOME/.sui/sui_config/`

### 7. Удостовериться, что адрес создан і зберігаємо його

`sui keytool list`

Публикация RPC ноды

### 8. На сервере выполнить команду ниже, чтобы получить RPC ноды

`echo "http://`wget -qO- eth0.me`:9000/"`

⠀Открыть ссылку в браузере на своём ПК, должна появиться надпись (если не появилась, значит нода не работает)

Used HTTP Method is not allowed. POST or OPTIONS is required

Для отправки своего RPC необходимо присоединиться к Discord серверу и отправить его в специальный канал. При этом желательно поддерживать работоспособность ноды до начала стимулирующей тестовой сети.

## 9. Запросить токены с крана. Вывести и скопировать адрес кошелька (в левой колонке)

`sui keytool list`

### Перейти в каналы:

https://discord.gg/sui

https://discord.com/channels/916379725201563759/971488439931392130

#✅・1st-step-verify и нажать на каплю;
#📕・2nd-step-rules и нажать галочку;
#🚰・devnet-faucet и отправить команду с адресом кошелька:

!faucet 0x___

## 10. Создать NFT
### NFT-образец создаётся командой

`sui client create-example-nft`

# 11. Готово

## Рестарт ноды:

`sudo systemctl restart suid`

## Остановить ноду:

`sudo systemctl stop suid`

## Удалить ноду:

`sudo systemctl stop suid`

`sudo systemctl disable suid`

`rm -rf ~/sui /var/sui/ /usr/local/bin/sui*`

`rm /etc/systemd/system/suid.service`
