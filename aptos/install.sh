#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/docker.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/docker-compose.sh | bash &>/dev/null
sudo apt install --fix-broken -y &>/dev/null
sudo apt install wget nano mc -y &>/dev/null
source .profile
source .bashrc
sleep 1

echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"

mkdir $HOME/aptos
cd $HOME/aptos
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/docker-compose.yaml &>/dev/null
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/public_full_node.yaml &>/dev/null
wget https://devnet.aptoslabs.com/genesis.blob &>/dev/null
wget https://devnet.aptoslabs.com/waypoint.txt &>/dev/null

docker-compose up -d

echo "=================================================="

echo -e "\e[1m\e[32mAptos FullNode Installed \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32mTo stop the Aptos Node: \e[0m"
echo -e "\e[1m\e[39m    docker compose stop \n \e[0m"

echo -e "\e[1m\e[32mTo start the Aptos Node: \e[0m"
echo -e "\e[1m\e[39m    docker compose start \n \e[0m"

echo -e "\e[1m\e[32mTo check the Aptos Node Logs: \e[0m"
echo -e "\e[1m\e[39m    docker logs -f aptos-fullnode-1 --tail 5000 \n \e[0m"

echo -e "\e[1m\e[32mTo check the node status: \e[0m"
echo -e "\e[1