#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

echo "Устанавливаем ноду"
echo "-----------------------------------------------------------------------------"

getGoland()
  {
	
	cd $HOME
	wget -O go1.17.2.linux-amd64.tar.gz https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz && rm go1.17.2.linux-amd64.tar.gz
	echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
	echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
	echo 'export GO111MODULE=on' >> $HOME/.bash_profile
	echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
	}
getDependencies(){
	
	cd $HOME
	sudo apt update && sudo apt upgrade -y
	sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof fail2ban -y

}


installTools() {
 
	rm -r $HOME/defund
	
git clone https://github.com/defund-labs/defund
cd defund
make install
	
. $HOME/.bash_profile 
defundd config chain-id defund-private-1



wget -O $HOME/.defund/config/genesis.json "https://raw.githubusercontent.com/defund-labs/defund/163e2669b6870aa26b73d843312b22c9948b29c6/testnet/private/genesis.json"

pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="1000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml


wget -O $HOME/.defund/config/addrbook.json "https://snapshots.bitszn.com/snapshots/scripts/addrbook_defund.json"
  
}

startService()
{
sudo tee /etc/systemd/system/defundd.service > /dev/null <<EOF
[Unit]
Description=defundd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which defundd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl restart defundd && journalctl -u defundd -f -o cat
}



getDependencies
getGoland
installTools 
startService

	
