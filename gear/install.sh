#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash
echo "-----------------------------------------------------------------------------"

if [ ! $NODENAME_GEAR ]; then
	read -p "Введите ваше имя ноды (придумайте, без спецсимволов - только буквы и цифры, например ваш логин в телеграмме): " NODENAME_GEAR
fi
echo 'Ваше имя ноды: ' $NODENAME_GEAR
sleep 1
echo 'export NODENAME='$NODENAME_GEAR >> $HOME/.profile
echo "-----------------------------------------------------------------------------"
echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/utils/rust.sh | bash &>/dev/null
sudo apt install --fix-broken -y &>/dev/null
sudo apt install nano mc git mc clang curl jq htop net-tools libssl-dev llvm libudev-dev -y &>/dev/null
source $HOME/.profile &>/dev/null
source $HOME/.bashrc &>/dev/null
source $HOME/.cargo/env &>/dev/null
sleep 1
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"

wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz &>/dev/null
tar xvf gear-nightly-linux-x86_64.tar.xz &>/dev/null
rm gear-nightly-linux-x86_64.tar.xz &>/dev/null
chmod +x $HOME/gear-node &>/dev/null
echo "Билд завершен успешно"
echo "-----------------------------------------------------------------------------"

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/gear.service
[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear-node \
        --name $NODENAME_GEAR \
        --execution wasm \
        --log runtime \
        --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
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
sudo systemctl enable gear &>/dev/null
sudo systemctl restart gear &>/dev/null

echo "Нода добавлена в автозагрузку на сервере, запущена"
echo "-----------------------------------------------------------------------------"

echo -e "\e[1m\e[32mTo restart the Gear Node: \e[0m"
echo -e "\e[1m\e[39m    sudo systemctl restart gear \n \e[0m"

echo -e "\e[1m\e[32mTo start the Gear Node: \e[0m"
echo -e "\e[1m\e[39m    systemctl stop gear \n \e[0m"


echo -e "\e[1m\e[32mTo start the Gear Node: \e[0m"
echo -e "\e[1m\e[39m    systemctl start gear \n \e[0m"

echo -e "\e[1m\e[32mTo check the Gear Node Logs: \e[0m"
echo -e "\e[1m\e[39m    journalctl -n 100 -f -u gear \n \e[0m"
