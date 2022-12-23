# Запустити для установки

`bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/namada/namada_install.sh)`

### Перевірити у логах яка висота блоку і ДОЧЕКАТИСЬ синхронізації на сервері

### Перевіряємо висоту блоку командою

`namada client block`

### Порівняти висоту блоку і в експлорері

explorer - https://namada.world/

## Запустити скріпт створення ключів і отримання тестових монет 
 
 `bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/namada/namada_gen_wallet.sh)`

### Перевіряємо баланс

`namada client balance --owner $VALIDATOR_ALIAS --token NAM`


## Придумуємо пароль і багато раз вписуємо один і той сами пароль!

### Виводимо свій адрес 

``export WALLET_ADDRESS=`cat "$HOME/.namada/public-testnet-1.0.05ab4adb9db/wallet.toml" | grep address` ``

``echo -e '\n\e[45mYour wallet:' $WALLET_ADDRESS '\e[0m\n'``

### Очікуємо мінімум 2 епохи і перевіряємо статус ноди 
### Наш адрес має мати застейкані токени
### Шукаємо свій адрес у списку адрес які застейкали монети

`namada client bonded-stake`
