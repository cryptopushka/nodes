#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"
if [ ! $ALCHEMY_KEY ]; then
	read -p "Введите ваш HTTP (ПРИМЕР: https://eth-goerli.alchemyapi.io/v2/xZXxxxxxxxxxxc2q_bzxxxxxxxxxxWTN): " ALCHEMY_KEY
fi
echo 'Ваш ключ: ' $ALCHEMY_KEY
sleep 1
echo 'export ALCHEMY_KEY='$ALCHEMY_KEY >> $HOME/.bash_profile
echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"

sudo apt update -y &>/dev/null
sudo apt install build-essential libssl-dev libffi-dev python3-dev screen git python3-pip python3.*-venv -y &>/dev/null
sudo apt-get install libgmp-dev -y &>/dev/null
pip3 install fastecdsa &>/dev/null
sudo apt-get install -y pkg-config &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/rust.sh | bash &>/dev/null
rustup default nightly &>/dev/null
source $HOME/.cargo/env &>/dev/null
sleep 1
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"

git clone --branch v0.1.6-alpha https://github.com/eqlabs/pathfinder.git &>/dev/null
cd pathfinder/py &>/dev/null
python3 -m venv .venv &>/dev/null
source .venv/bin/activate &>/dev/null
PIP_REQUIRE_VIRTUALENV=true pip install --upgrade pip &>/dev/null
PIP_REQUIRE_VIRTUALENV=true pip install -r requirements-dev.txt &>/dev/null
cargo build --release --bin pathfinder &>/dev/null
sleep 2
source $HOME/.bash_profile &>/dev/null
echo "Билд завершен успешно"
echo "-----------------------------------------------------------------------------"

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/starknet.service
[Unit]
Description=StarkNet Node
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/pathfinder/py
Environment=PATH="$HOME/pathfinder/py/.venv/bin:\$PATH"
ExecStart=$HOME/pathfinder/target/release/pathfinder --ethereum.url $ALCHEMY_KEY
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
EOF

echo "Сервисные файлы созданы успешно"
echo "-----------------------------------------------------------------------------"

sudo systemctl restart systemd-journald &>/dev/null
sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable starknet &>/dev/null
sudo systemctl restart starknet &>/dev/null

echo -e "\e[1m\e[32mНода добавлена в автозагрузку на сервере, запущена\e[0m"
echo "-----------------------------------------------------------------------------"

echo -e "\e[1m\e[32mВаш ключ: \e[0m"
echo -e "\e[1m\e[39m"    $ALCHEMY_KEY" \n \e[0m"

echo -e "\e[1m\e[32mTo check node status: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl status starknet \n \e[0m"

echo -e "\e[1m\e[32mTo view logs: \e[0m"
echo -e "\e[1m\e[39m    journalctl -n 100 -f -u starknet \n \e[0m"

echo -e "\e[1m\e[32mTo stop: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl stop starknet \n \e[0m"

echo -e "\e[1m\e[32mTo start: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl start starknet \n \e[0m"

echo -e "\e[1m\e[32mTo restart: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl restart starknet \n \e[0m"