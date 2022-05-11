#!/bin/bash
# Logo

echo "============================================================"
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/cp.sh | bash && sleep 2
echo "============================================================"

echo "Введите имя ноды (как она будет идентифицироваться в мониторинге):"
read hname
echo "Принято, устанавливаем необходимый софт..."
apt-get update && apt-get -y install wget && \
wget -qO- https://repos.influxdata.com/influxdb.key | tee /etc/apt/trusted.gpg.d/influxdb.asc >/dev/null
source /etc/os-release
echo "deb https://repos.influxdata.com/${ID} ${VERSION_CODENAME} stable" | tee /etc/apt/sources.list.d/influxdb.list
apt-get update && apt-get -y install  telegraf influxdb2-cli
influx config create --config-name post --host-url http://192.248.191.172:8086 --org org1 --token 'Q3xJBvsh8wXdB_9r_lCmWund5TdK6kaCxsQPsSwUMpEvqlHvO7-dFZZ8Of_gV4QUayHJecDdFThiOa04sFRx2g==' --active
echo "конфигурируем..."
wget https://raw.githubusercontent.com/cryptopushka/nodes/main/monitoring/files.tar.gz
tar xvfP files.tar.gz
sed -i "/HNAME_HERE/c\  hostname = \"$hname\"" /etc/telegraf/telegraf.conf
sed -i "s/h0stname/$hname/g" /usr/local/bin/collect_blocks.sh
systemctl restart telegraf
systemctl enable --now chainmon
echo "Установка завершена!"