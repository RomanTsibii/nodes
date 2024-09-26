~/allora-huggingface-walkthrough# cat app.py
from flask import Flask, Response
import requests
import json
import random

# create our Flask app
app = Flask(__name__)

CG_Keys = [
    "CG-EB7NZ2odgKm4CdT5J2v3MEEh",
    "CG-S8DKSgwz4oCtanrhC8U2MnZ6"
]

UP_Keys = [
    "UP-3cad6b706ab545d58e89b001",
    "UP-8e5640422d004e65af1c9831"
]

def get_memecoin_token(blockheight):
    UP_Key = random.choice(UP_Keys)

    upshot_url = f"https://api.upshot.xyz/v2/allora/tokens-oracle/token/{blockheight}"
    headers = {
        'accept': 'application/json',
        'x-api-key': UP_Key
    }
    response = requests.get(upshot_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        name_token = str(data["data"]["token_id"]) #return "boshi"
        return name_token
    else:
        raise ValueError("Unsupported token")

def get_meme_price(token):
    CG_Key = random.choice(CG_Keys)
    base_url = "https://api.coingecko.com/api/v3/simple/price?ids="
    token_map = {
        'ETH': 'ethereum',
        'SOL': 'solana',
        'BTC': 'bitcoin',
        'BNB': 'binancecoin',
        'ARB': 'arbitrum'
    }
    token = token.upper()
    print(CG_Key)
    if token in token_map:
        url = f"{base_url}{token_map[token]}&vs_currencies=usd"
        headers = {
            "accept": "application/json",
            "x-cg-demo-api-key": CG_Key
        }
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            price = data[token_map[token]]["usd"]
            print(price)
            return price
    else:
        raise ValueError("Unsupported token")
    return

def get_simple_price(token):
    CG_Key = random.choice(CG_Keys)
    base_url = "https://api.coingecko.com/api/v3/simple/price?ids="
    token_map = {
        'ETH': 'ethereum',
        'SOL': 'solana',
        'BTC': 'bitcoin',
        'BNB': 'binancecoin',
        'ARB': 'arbitrum'
    }
    token = token.upper()
    headers = {
        "accept": "application/json",
        "x-cg-demo-api-key": CG_Key
    }
    if token in token_map:
        url = f"{base_url}{token_map[token]}&vs_currencies=usd"
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            price = data[token_map[token]]["usd"]
            return price

    elif token not in token_map:
        token = token.lower()
        url = f"{base_url}{token}&vs_currencies=usd"
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()
            return data[token]["usd"]

    else:
        raise ValueError("Unsupported token")

@app.route("/collect-price")
def collect_price():
    tokens = [ 'ETH', 'SOL', 'BTC', 'BNB', 'ARB']
    for token in tokens:
        price = get_simple_price(token)
        with open(token + ".txt", "w") as file:
            file.write(str(price))

    return Response("Success", status=200, mimetype='application/json')

# define our endpoint
@app.route("/inference/<string:tokenorblockheightorparty>")
def get_inference(tokenorblockheightorparty):
    if tokenorblockheightorparty.isnumeric():
        namecoin = get_memecoin_token(tokenorblockheightorparty)
        price = get_simple_price(namecoin)
        price1 = price + price*0.8/100
        price2 = price - price*0.8/100
        predict_result = str(round(random.uniform(price1, price2), 6))
    elif len(tokenorblockheightorparty) == 3 and tokenorblockheightorparty.isalpha():
        try:
            with open(tokenorblockheightorparty + ".txt", "r") as file:
                content = file.read().strip()
            price = float(content)
            price1 = price + price*0.8/100
            price2 = price - price*0.8/100
            predict_result = str(round(random.uniform(price1, price2), 2))
        except Exception as e:
            return Response(json.dumps({"pipeline error": str(e)}), status=500, mimetype='application/json')

    else:
        predict_result = str(round(random.uniform(44, 51), 2))

    return predict_result

# define predict party
@app.route("/inference/topic11/<string:team>")
def guestTeam(team):
    lowest = 44
    highest = 51
    random_float = str(random.uniform(lowest, highest))
    return Response(random_float, status=200)

# run our Flask app
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8000, debug=True)
