
ticker=IRON
#ticker=BTC
#ticker=ETH
req1=$(curl -s https://api.kucoin.com/api/v2/symbols)
req2=$(curl -s https://api.kucoin.com/api/v1/market/allTickers)

while true
do
    
    if [[ $req1 == *"$ticker"* ]]; then
      text="find ${ticker} at Symbols"
      curl -s --data "text=$text" --data "chat_id=$chat_id1" 'https://api.telegram.org/bot'$apitoken'/sendMessage' > /dev/null 
      curl -s --data "text=$text" --data "chat_id=$chat_id2" 'https://api.telegram.org/bot'$apitoken'/sendMessage' > /dev/null
    fi
    
    if [[ $req2 == *"$ticker"* ]]; then
      text="find ${ticker} at allTickers"
      curl -s --data "text=$text" --data "chat_id=$chat_id1" 'https://api.telegram.org/bot'$apitoken'/sendMessage' > /dev/null
      curl -s --data "text=$text" --data "chat_id=$chat_id2" 'https://api.telegram.org/bot'$apitoken'/sendMessage' > /dev/null
    fi
    sleep 10
done

