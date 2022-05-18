# Starknet Node


## Минимальный системные требования 

4 core CPU, 4GB RAM 60 GB



## Prepare system before install
```
sudo apt update && sudo apt upgrade -y
```

```
sudo apt install curl
```

## install node
```
curl -s https://raw.githubusercontent.com/cryptopushka/nodes/main/starknet/install.sh > starknet_install.sh && chmod +x starknet_install.sh && ./starknet_install.sh
```

## Check logs

```
journalctl -n 100 -f -u starknet
```
