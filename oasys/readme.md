# Oasys Node

## Recommended Environment 

2 core CPU, 8GB RAM 100 GB SSD

## Install node
```
wget -q -O oasys.sh https://raw.githubusercontent.com/cryptopushka/nodes/main/oasys/oasys.sh && chmod +x oasys.sh && sudo /bin/bash oasys.sh
```

## Additional commands

## Check logs

```
journalctl -u oasysd -f
```

## Restart node

```
systemctl restart oasysd
```

## Check node sync, if status = False, then node synced

```
sudo -u geth geth attach ipc:/home/geth/.ethereum/geth.ipc --exec eth.syncing
```

## Delete node

```
systemctl stop oasysd
systemctl disable oasysd
rm -rf /home/geth/*
rm /etc/systemd/system/oasysd.service
```

## Node using ports:

```
TCP/UDP port 30303
TCP port 8545
```