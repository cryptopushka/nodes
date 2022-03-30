#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

echo "Обновляем ноду aptos"

cd $HOME/aptos
docker-compose stop
rm -r /var/lib/docker/volumes/aptos_db/_data/db
rm genesis.blob &>/dev/null
rm waypoint.txt &>/dev/null

wget https://devnet.aptoslabs.com/genesis.blob &>/dev/null
wget https://devnet.aptoslabs.com/waypoint.txt &>/dev/null

docker-compose start

echo "=================================================="

echo -e "\e[1m\e[32mAptos FullNode Updated \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32mTo stop the Aptos Node: \e[0m"
echo -e "\e[1m\e[39m    docker compose stop \n \e[0m"

echo -e "\e[1m\e[32mTo start the Aptos Node: \e[0m"
echo -e "\e[1m\e[39m    docker compose start \n \e[0m"

echo -e "\e[1m\e[32mTo check the Aptos Node Logs: \e[0m"
echo -e "\e[1m\e[39m    docker logs -f aptos-fullnode-1 --tail 5000 \n \e[0m"

echo -e "\e[1m\e[32mTo check the node status: \e[0m"
echo -e "\e[1m\e[39m    curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type \n \e[0m"