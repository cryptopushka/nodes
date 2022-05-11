#!/bin/bash

while true
do

# Logo

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

# Menu

PS3='Select an action: '
options=(
"Install Node"
"Check Log"
"Check balance"
"Request tokens in discord"
"Create Validator"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install Node")
echo "============================================================"
echo "Install start"
echo "============================================================"
echo "Setup NodeName:"
echo "============================================================"
read NODENAME
echo "============================================================"
echo "Setup WalletName:"
echo "============================================================"
read WALLETNAME
echo export NODENAME=${NODENAME} >> $HOME/.bash_profile
echo export WALLETNAME=${WALLETNAME} >> $HOME/.bash_profile
echo export CHAIN_ID=galaxy-1 >> $HOME/.bash_profile
source ~/.bash_profile

#UPDATE APT
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

#INSTALL GO
wget https://golang.org/dl/go1.16.6.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz && \
rm -v go1.16.6.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version

#INSTALL
cd $HOME
git clone https://github.com/galaxies-labs/galaxy
cd galaxy
git checkout v1.0.0
make install

rm $HOME/.galaxy/config/genesis.json
galaxyd init $NODENAME --chain-id $CHAIN_ID
galaxyd config chain-id $CHAIN_ID


echo "============================================================"
echo "Be sure to write down the mnemonic!"
echo "============================================================"
#WALLET
galaxyd keys add $WALLETNAME

galaxyd unsafe-reset-all
rm $HOME/.galaxy/config/genesis.json
wget -O $HOME/.galaxy/config/genesis.json "https://media.githubusercontent.com/media/galaxies-labs/networks/main/galaxy-1/genesis.json"

external_address=$(wget -qO- eth0.me)
peers="bf446887a7a00c8babfeba2f92ba569a206a3ea7@65.108.71.140:26676,1e9ee1911298a15128c8485ea47b18be08939e01@136.244.29.116:38656,a4bd8fed416aa29d9cc061e2b9dffa7f4b679c91@65.21.131.144:30656,801f4e17769bd2ee02b27720d901a42cb8d052ea@65.108.192.3:24656,8fc2d8c2fadd278eae617a9c2a2f008e01e8ef68@206.246.71.251:26656,10f7caa39969dc36450b138848a06e7deabe6fed@95.111.244.128:26656,cd8fd9e1677c701015b8909116f88974028cd0b4@203.135.141.28:26656,b4b6f1563f2891ed5735d6133d78fc7c17ce12d0@185.234.69.139:26656,5b3fd251b74e6af11f4c71d420fd1837f4869e85@45.33.62.64:26656,51b3263a333de94198fe4c4d819b48fbd107f93a@5.9.13.234:26356,e21bf32eaedee13d8dc240baacf23fee97a8edac@141.94.141.144:43656,8b447bd4fa1e56d8252538a6e23573e5e78924fa@161.97.155.94:26656,8d059154ea0a6e25c5695a1e163e601482769604@95.217.207.236:31256,7ded7314f57a078076507d7b291e100ad2dc158b@65.108.41.172:36656"
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.galaxy/config/config.toml
seeds="574e8402e255f895680db2904168724258fd6ff8@13.125.60.249:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.galaxy/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.galaxy/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.galaxy/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.galaxy/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.galaxy/config/app.toml


tee $HOME/galaxyd.service > /dev/null <<EOF
[Unit]
Description=galaxy
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which galaxyd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/galaxyd.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable galaxyd
sudo systemctl restart galaxyd

break
;;

"Check Log")

journalctl -u galaxyd -f -o cat

break
;;


"Check balance")
galaxyd q bank balances $(galaxyd keys show $WALLETNAME -a --bech acc)
break
;;

"Create Validator")
galaxyd tx staking create-validator \
  --amount 1000000uglx \
  --from $WALLETNAME \
  --commission-max-change-rate "0.05"\
  --commission-max-rate "0.20"\
  --commission-rate "0.05"\
  --min-self-delegation "1" \
  --pubkey $(galaxyd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CHAIN_ID \
  --gas 200000 \
  -y
break
;;

"Request tokens in discord")
echo "========================================================================================================================"
echo "In order to receive tokens, you need to go to the Discord server
and request tokens in the validator channel"
echo "========================================================================================================================"

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
