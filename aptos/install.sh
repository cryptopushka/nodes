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
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/docker-compose.yaml
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/public_full_node.yaml
wget https://devnet.aptoslabs.com/genesis.blob
wget https://devnet.aptoslabs.com/waypoint.txt

docker compose up -d