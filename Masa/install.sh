#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

if [ ! $MASA_NODENAME ]; then
	read -p "Введите ваше имя ноды (придумайте, без спецсимволов - только буквы и цифры): " MASA_NODENAME
fi
echo 'Имя вашей ноды: '$MASA_NODENAME
sleep 1
echo 'export MASA_NODENAME='$MASA_NODENAME >> $HOME/.profile
echo "-----------------------------------------------------------------------------"
echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/rust.sh | bash &>/dev/null
sudo apt install --fix-broken -y &>/dev/null
sudo apt install nano mc wget -y &>/dev/null
source $HOME/.profile &>/dev/null
source $HOME/.bashrc &>/dev/null
sleep 1
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"

cd $HOME
sudo apt install apt-transport-https -y &>/dev/null

if [ ! -d $HOME/masa-node-v1.0/ ]; then
  git clone https://github.com/masa-finance/masa-node-v1.0 &>/dev/null
fi
cd $HOME/masa-node-v1.0/src
git checkout v1.03
make all &>/dev/null
go get github.com/ethereum/go-ethereum/accounts/keystore &>/dev/null
cd $HOME/masa-node-v1.0/src/build/bin
cp * /usr/local/bin
echo "Ставим geth quorum"
cd $HOME
wget https://artifacts.consensys.net/public/go-quorum/raw/versions/v21.10.0/geth_v21.10.0_linux_amd64.tar.gz &>/dev/null
tar -xvf geth_v21.10.0_linux_amd64.tar.gz &>/dev/null
rm -v geth_v21.10.0_linux_amd64.tar.gz &>/dev/null
chmod +x $HOME/geth
sudo mv -f $HOME/geth /usr/bin/
echo "Инициализируем ноду"
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json
PRIVATE_CONFIG=ignore
echo 'export PRIVATE_CONFIG='${PRIVATE_CONFIG} >> $HOME/.profile
source $HOME/.profile
sudo tee /etc/systemd/system/masad.service > /dev/null <<EOF
[Unit]
Description=MASA
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/geth --identity ${MASA_NODENAME} --datadir $HOME/masa-node-v1.0/data --bootnodes enode://aaf136ec1d53d0980294c838deb4492414e220f0cc60bb62b54bdb6eade1d314afbcbd7257d88e73135e63c07413e8fb538f64e047bea9e9b8ae394d84fc345d@49.161.210.223:30300  --emitcheckpoints --istanbul.blockperiod 1 --mine --minerthreads 1 --syncmode full --verbosity 5 --networkid 190250 --rpc --rpccorsdomain "*" --rpcvhosts "*" --rpcaddr 127.0.0.1 --rpcport 8545 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --port 30300
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable masad
sudo systemctl restart masad

echo 'ГОТОВО!';

echo -e "\e[1m\e[32mПосмотреть статус ноды: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl status masad \n \e[0m"

echo -e "\e[1m\e[32m Посмотреть логи ноды: \e[0m"
echo -e "\e[1m\e[39m    systemctl stop gear \n \e[0m"


echo -e "\e[1m\e[32mРестарт ноды: \e[0m"
echo -e "\e[1m\e[39m    journalctl -n 100 -f -u masad: \n \e[0m"
