#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/nubit/update.sh) 

rm -rf .nubit-light-nubit-alphatestnet-1
if [ ! -f $HOME/nubit-node/mnemonic.txt ]; then
    echo "Cначала создайте mnemonic.txt и положите его в папку $HOME/nubit-node"
    exit 1
fi

echo "Удаление старых данных с ноды Nubit"

cd $HOME/nubit-node
rm -rf Dockerfile

docker rm -f nubit
docker stop nubit-10
docker images | grep "nubit" | awk '{print $3}' | xargs docker rmi -f
docker start nubit-10

echo "-----------------------------------------------------------------------------"
echo "Обновление ноды Nubit"
echo "-----------------------------------------------------------------------------"

wget -O Dockerfile https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/nubit/Dockerfile.update

docker build --no-cache -t nubit_image . && docker run -d --name nubit --restart always nubit_image && docker exec -it nubit ./expect.sh
docker restart nubit


echo "-----------------------------------------------------------------------------"
echo "Light Nubit Node успешно обновлена"
echo "-----------------------------------------------------------------------------"
echo "Проверка логов:"
echo "docker logs -f --tail=100 nubit"
echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with DOUBLETOP"
echo "-----------------------------------------------------------------------------"
